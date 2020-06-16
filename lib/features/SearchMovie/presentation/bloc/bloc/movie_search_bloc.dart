import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:movie_browser/core/error/failures.dart';
import 'package:movie_browser/features/SearchMovie/domain/usecases/get_movie_details.dart'
    as g;
import 'package:movie_browser/features/SearchMovie/domain/usecases/search_movie.dart'
    as s;

import '../../../data/models/movie_detailed_model.dart';
import '../../../data/models/search_result_model.dart';

part 'movie_search_event.dart';
part 'movie_search_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure.\nPlease try again later';
const String NETWORK_FAILURE_MESSAGE =
    'Network connection not found.\nAre you sure you\'re connected to the internet?';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final s.SearchMovie searchMovie;
  final g.GetMovieDetails getMovieDetails;

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
    if (event is SearchMovieEvent) {
      yield* _searchMovie(searchMovie, event.title, event.page);
    } else if (event is SearchMovieFirstPageEvent) {
      yield* _searchMovie(searchMovie, event.title, 1);
    } else if (event is SearchMovieLastPageEvent) {
      yield* _searchMovie(searchMovie, event.title, event.page);
    }

    // GetMovieDetailsEvent.  Yields Loading state, awaits details, then emits
    // error state or loaded state
    else if (event is GetMovieDetailsEvent) {
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
) async* {
  yield SearchLoading();
  final eitherSearchResult =
      await searchMovie(s.Params(title: title, page: page));
  yield* eitherSearchResult.fold(
    // emits appropriate errors + messages
    (failure) async* {
      yield SearchError(message: _mapFailureToMessage(failure));
    },
    (searchResult) async* {
      // handles pagination if needed
      if (searchResult.totalResults > 10) {
        final int totalPages = (searchResult.totalResults / 10).ceil();

        yield SearchLoaded(
          searchResult: searchResult,
          displayPagination: true,
          displayFirstPageButton: searchResult.page > 2 ? true : false,
          displayPrevPageButton: searchResult.page > 1 ? true : false,
          displayNextPageButton: searchResult.page < totalPages ? true : false,
          displayFinalPageButton:
              searchResult.page < totalPages - 1 ? true : false,
        );
      } else {
        yield SearchLoaded(
          searchResult: searchResult,
          displayPagination: false,
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
