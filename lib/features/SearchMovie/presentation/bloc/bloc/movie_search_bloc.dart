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
      final eitherSearchResult =
          await searchMovie(s.Params(title: event.title, page: event.page));

      yield* eitherSearchResult.fold(
        (failure) async* {
          if (failure is NetworkFailure) {
            yield SearchError(message: NETWORK_FAILURE_MESSAGE);
          } else {
            yield SearchError(message: SERVER_FAILURE_MESSAGE);
          }
        },
        (searchResult) async* {
          yield SearchLoading();

          if (searchResult.totalResults > 10) {
            final int totalPages = (searchResult.totalResults / 10).ceil();

            yield SearchLoaded(
              searchResult: searchResult,
              displayPagination: true,
              displayFirstPageButton: searchResult.page > 2 ? true : false,
              displayPrevPageButton: searchResult.page > 1 ? true : false,
              displayNextPageButton: searchResult.page < totalPages ? true : false,
              displayFinalPageButton: searchResult.page < totalPages - 1 ? true : false,
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
  }
}
