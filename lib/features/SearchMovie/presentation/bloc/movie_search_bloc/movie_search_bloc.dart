import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:movie_browser/core/error/failures.dart';
import 'package:movie_browser/features/SearchMovie/data/models/movie_brief_hive_model.dart';
import 'package:movie_browser/features/SearchMovie/data/models/movie_detailed_hive_model.dart';
import 'package:movie_browser/features/SearchMovie/data/models/search_result_hive_model.dart';
import 'package:movie_browser/features/SearchMovie/domain/usecases/get_movie_details.dart'
    as g;
import 'package:movie_browser/features/SearchMovie/domain/usecases/search_movie.dart'
    as s;

part 'movie_search_event.dart';
part 'movie_search_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure.\nPlease try again later';
const String NETWORK_FAILURE_MESSAGE =
    'Network connection not found.\nAre you sure you\'re connected to the internet?';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final s.SearchMovie searchMovie;
  final g.GetMovieDetails getMovieDetails;

  String _title = '';
  int _currentPage = 1;
  bool _nextPage = true;
  List<MovieBriefHive> _searchResultList = [];

  int get getPage => _currentPage;
  List<MovieBriefHive> get getResultsList => _searchResultList;
  String get getTitle => _title;

  void _resetResultList() {
    _searchResultList = [];
    _nextPage = true;
    _currentPage = 1;
  }

  void _updateResultList(List<MovieBriefHive> list) {
    _searchResultList = [..._searchResultList, ...list];
  }

  void _setNextPage(bool value) {
    _nextPage = value;
  }

  MovieSearchBloc({
    @required s.SearchMovie search,
    @required g.GetMovieDetails getDetails,
  })  : assert(search != null),
        assert(getDetails != null),
        searchMovie = search,
        getMovieDetails = getDetails;

  @override
  MovieSearchState get initialState => MovieSearchInitial();

  @override
  Stream<MovieSearchState> mapEventToState(
    MovieSearchEvent event,
  ) async* {
    // [TitleChangedEvent]
    if (event is TitleChangedEvent) {
      _title = event.title;
    }

    // [SearchMovieEvent]
    if (event is SearchMovieEvent) {
      // first reset our list if we're searching new movie
      _resetResultList();

      yield* _searchMovie(
        searchMovie,
        _title,
        1,
        _updateResultList,
        _setNextPage,
      );
    }

    if (event is SearchMovieMoreResultsEvent) {
      if (_nextPage) {
        _currentPage = _currentPage + 1;
        yield* _searchMovie(
          searchMovie,
          _title,
          _currentPage,
          _updateResultList,
          _setNextPage,
        );
      }
    }

    // GetMovieDetailsEvent.  Yields Loading state, awaits details, then emits
    // error state or loaded state
    if (event is GetMovieDetailsEvent) {
      yield DetailsLoading();
      final eitherMovieDetails = await getMovieDetails(g.Params(id: event.id));

      yield* eitherMovieDetails.fold(
        (failure) async* {
          yield DetailsError(message: _mapFailureToMessage(failure));
        },
        (movieDetailed) async* {
          yield DetailsLoaded(movieDetailed: movieDetailed);
        },
      );
    }
  }
}

Stream<MovieSearchState> _searchMovie(
  s.SearchMovie searchMovie,
  title,
  page,
  updateList,
  setNextPage,
) async* {
  print('should yield searchloading');
  yield SearchLoading();

  final eitherSearchResult =
      await searchMovie(s.Params(title: title, page: page));

  yield* eitherSearchResult.fold(
    // emits appropriate errors + messages
    (failure) async* {
      print('yielding error');
      setNextPage(false);
      yield SearchError(message: _mapFailureToMessage(failure));
    },
    (searchResult) async* {
      // decide if we can still show more results after this
      if (searchResult.totalResults <= page * 10) {
        setNextPage(false);
      }

      // yeilds an error state if search returned no results
      if (searchResult.found == false) {
        yield SearchError(message: 'No results');
      } else {
        // update our results lists and yield next state
        updateList(searchResult.results);
        yield SearchLoaded(
          searchResult: searchResult,
        );
      }
    },
  );
}

String _mapFailureToMessage(Failure failure) {
  /// displays the appropriate error message for each error type
  switch (failure.runtimeType) {
    case ServerFailure:
      return SERVER_FAILURE_MESSAGE;
    case NetworkFailure:
      return NETWORK_FAILURE_MESSAGE;
    default:
      return 'An unexpected error has occured';
  }
}
