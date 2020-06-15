import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_browser/core/error/failures.dart';
import 'package:movie_browser/features/SearchMovie/data/models/search_result_model.dart';
import 'package:movie_browser/features/SearchMovie/domain/usecases/get_movie_details.dart';
import 'package:movie_browser/features/SearchMovie/domain/usecases/search_movie.dart'
    as s;
import 'package:movie_browser/features/SearchMovie/presentation/bloc/bloc/movie_search_bloc.dart';

class MockSearchMovie extends Mock implements s.SearchMovie {}

class MockGetMovieDetails extends Mock implements GetMovieDetails {}

void main() {
  MovieSearchBloc bloc;
  MockSearchMovie mockSearchMovie;
  MockGetMovieDetails mockGetMovieDetails;

  setUp(() {
    mockSearchMovie = MockSearchMovie();
    mockGetMovieDetails = MockGetMovieDetails();

    bloc = MovieSearchBloc(
      search: mockSearchMovie,
      getDetails: mockGetMovieDetails,
    );
  });

  test('Initial state should be [MovieSearchInitial]', () {
    expect(bloc.initialState, equals(MovieSearchInitial()));
  });

  group('mockSearchMovie', () {
    final String title = "abc";
    final int testPage = 1;

    SearchResultModel _buildSearchResult(int page, int totalResults) {
      assert(page > 0);
      assert(totalResults > 0);

      return SearchResultModel(
        title: title,
        found: true,
        // page is variable for pagination
        page: page,
        totalResults: totalResults,
      );
    }

    Future<MovieSearchBloc> setUpSuccessfulSearch(
        int page, int totalResults) async {
      assert(page > 0);
      assert(totalResults > 0);

      when(mockSearchMovie(any)).thenAnswer(
        (_) async => Right(
          _buildSearchResult(page, totalResults),
        ),
      );
      return bloc;
    }

    test('Calls searchMovie usecase', () async {
      when(mockSearchMovie(any))
          .thenAnswer((_) async => Left(NetworkFailure()));

      bloc.add(SearchMovieEvent(title, testPage));
      await untilCalled(mockSearchMovie(any));

      verify(mockSearchMovie(s.Params(title: title, page: testPage)));
    });

    blocTest(
      'Emits [SearchError] when network error occurs',
      build: () async {
        when(mockSearchMovie(any))
            .thenAnswer((_) async => Left(NetworkFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(SearchMovieEvent(title, testPage)),
      expect: [
        SearchError(message: NETWORK_FAILURE_MESSAGE),
      ],
    );

    blocTest(
      'Emites [SearchError] with correct message when server error occurs',
      build: () async {
        when(mockSearchMovie(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(SearchMovieEvent(title, testPage)),
      expect: [
        SearchError(message: SERVER_FAILURE_MESSAGE),
      ],
    );

    blocTest(
      'should emit [SearchLoading], [SearchLoaded] when search is successful',
      build: () async => setUpSuccessfulSearch(1, 1),
      act: (bloc) => bloc.add(SearchMovieEvent(title, testPage)),
      expect: [
        SearchLoading(),
        SearchLoaded(
          searchResult: _buildSearchResult(1, 1),
          displayPagination: false,
        ),
      ],
    );
  });
}
