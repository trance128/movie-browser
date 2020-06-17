import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_browser/core/error/failures.dart';
import 'package:movie_browser/features/SearchMovie/data/models/movie_detailed_model.dart';
import 'package:movie_browser/features/SearchMovie/data/models/search_result_model.dart';
import 'package:movie_browser/features/SearchMovie/domain/usecases/get_movie_details.dart';
import 'package:movie_browser/features/SearchMovie/domain/usecases/search_movie.dart'
    as s;
import 'package:movie_browser/features/SearchMovie/presentation/bloc/movie_search_bloc/movie_search_bloc.dart';

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

  group('searchMovie', () {
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
        SearchLoading(),
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
        SearchLoading(),
        SearchError(message: SERVER_FAILURE_MESSAGE),
      ],
    );

    blocTest(
      'should emit [SearchLoading], [SearchLoaded] when search is successful',
      build: () async => setUpSuccessfulSearch(1, 1),
      act: (bloc) => bloc.add(SearchMovieEvent(title, 1)),
      expect: [
        SearchLoading(),
        SearchLoaded(
          searchResult: _buildSearchResult(1, 1),
          displayPagination: false,
        ),
      ],
    );

    group('displayPagination', () {
      blocTest(
        '[SearchLoaded] shows displayPagination as true if totalResuls > 10',
        build: () async => setUpSuccessfulSearch(1, 11),
        act: (bloc) => bloc.add(SearchMovieEvent(title, 1)),
        expect: [
          SearchLoading(),
          SearchLoaded(
            searchResult: _buildSearchResult(1, 11),
            displayPagination: true,
            displayNextPageButton: true,
          ),
        ],
      );

      blocTest(
        'displayFirst is false, displayNext is true when page is 1 and totalResults > 10',
        build: () async => setUpSuccessfulSearch(1, 11),
        act: (bloc) => bloc.add(SearchMovieEvent(title, 1)),
        expect: [
          SearchLoading(),
          SearchLoaded(
            searchResult: _buildSearchResult(1, 11),
            displayPagination: true,
            displayFirstPageButton: false,
            displayNextPageButton: true,
          )
        ],
      );

      blocTest(
        'displayPrev is true, displayNext is false when page is 2 and totalResults > 10',
        build: () async => setUpSuccessfulSearch(2, 11),
        act: (bloc) => bloc.add(SearchMovieEvent(title, 2)),
        expect: [
          SearchLoading(),
          SearchLoaded(
            searchResult: _buildSearchResult(2, 11),
            displayPagination: true,
            displayPrevPageButton: true,
            displayNextPageButton: false,
          )
        ],
      );

      blocTest(
        'displayPrev is true, displayNext is true when page is 2 and totalResults > 20',
        build: () async => setUpSuccessfulSearch(2, 21),
        act: (bloc) => bloc.add(SearchMovieEvent(title, 2)),
        expect: [
          SearchLoading(),
          SearchLoaded(
            searchResult: _buildSearchResult(2, 21),
            displayPagination: true,
            displayPrevPageButton: true,
            displayNextPageButton: true,
          )
        ],
      );

      blocTest(
        'displayFirst is true, displayPrev is true when page is 3 and totalResults > 20',
        build: () async => setUpSuccessfulSearch(3, 21),
        act: (bloc) => bloc.add(SearchMovieEvent(title, 3)),
        expect: [
          SearchLoading(),
          SearchLoaded(
            searchResult: _buildSearchResult(3, 21),
            displayPagination: true,
            displayFirstPageButton: true,
            displayPrevPageButton: true,
          )
        ],
      );

      blocTest(
        'displayFirst, displayPrev, & displayNext are true, when page is 3 and totalResults > 30',
        build: () async => setUpSuccessfulSearch(3, 31),
        act: (bloc) => bloc.add(SearchMovieEvent(title, 3)),
        expect: [
          SearchLoading(),
          SearchLoaded(
            searchResult: _buildSearchResult(3, 31),
            displayPagination: true,
            displayFirstPageButton: true,
            displayNextPageButton: true,
            displayPrevPageButton: true,
          )
        ],
      );

      blocTest(
        'all display properties are true, when page is 3 and totalResults > 40',
        build: () async => setUpSuccessfulSearch(3, 41),
        act: (bloc) => bloc.add(SearchMovieEvent(title, 3)),
        expect: [
          SearchLoading(),
          SearchLoaded(
            searchResult: _buildSearchResult(3, 41),
            displayPagination: true,
            displayFirstPageButton: true,
            displayNextPageButton: true,
            displayPrevPageButton: true,
            displayFinalPageButton: true,
          )
        ],
      );

      blocTest(
        'all display properties are true except displayFirst, when page is 2 and totalResults > 40',
        build: () async => setUpSuccessfulSearch(2, 41),
        act: (bloc) => bloc.add(SearchMovieEvent(title, 2)),
        expect: [
          SearchLoading(),
          SearchLoaded(
            searchResult: _buildSearchResult(2, 41),
            displayPagination: true,
            displayFirstPageButton: false,
            displayNextPageButton: true,
            displayPrevPageButton: true,
            displayFinalPageButton: true,
          )
        ],
      );

      blocTest(
        'displayNext and displayFinal are true, when page is 1 and totalResults > 20',
        build: () async => setUpSuccessfulSearch(1, 21),
        act: (bloc) => bloc.add(SearchMovieEvent(title, 1)),
        expect: [
          SearchLoading(),
          SearchLoaded(
            searchResult: _buildSearchResult(1, 21),
            displayPagination: true,
            displayFirstPageButton: false,
            displayPrevPageButton: false,
            displayNextPageButton: true,
            displayFinalPageButton: true,
          )
        ],
      );
    });

    group('searchMovie Page events', () {
      test(
          '[SearchMovieFirstPageEvent] calls searchMovie usecase with page = 1',
          () async {
        when(mockSearchMovie(any))
            .thenAnswer((_) async => Left(NetworkFailure()));

        bloc.add(SearchMovieFirstPageEvent(title));
        await untilCalled(mockSearchMovie(any));

        verify(mockSearchMovie(s.Params(title: title, page: 1)));
      });

      test('[SearchMovieLastPageEvent] calls searchMovie usecase with page = 1',
          () async {
        when(mockSearchMovie(any))
            .thenAnswer((_) async => Left(NetworkFailure()));

        bloc.add(SearchMovieLastPageEvent(title, 3));
        await untilCalled(mockSearchMovie(any));

        verify(mockSearchMovie(s.Params(title: title, page: 3)));
      });
    });
  });

  group('getMovieDetails', () {
    final String id = "tt123";
    final String title = "abc";
    final MovieDetailedModel movieDetailed =
        MovieDetailedModel(id: id, title: title, year: 2020);

    test('calls getMovieDetails usecase', () async {
      when(mockGetMovieDetails(any))
          .thenAnswer((_) async => Left(NetworkFailure()));

      bloc.add(GetMovieDetailsEvent(id));
      await untilCalled(mockGetMovieDetails(any));

      verify(mockGetMovieDetails(any));
    });

    blocTest(
      'Emits [DetailsError] when network error occurs',
      build: () async {
        when(mockGetMovieDetails(any))
            .thenAnswer((_) async => Left(NetworkFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetMovieDetailsEvent(id)),
      expect: [
        DetailsLoading(),
        DetailsError(message: NETWORK_FAILURE_MESSAGE),
      ],
    );

    blocTest(
      'Emites [DetailsError] with correct message when server error occurs',
      build: () async {
        when(mockGetMovieDetails(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetMovieDetailsEvent(id)),
      expect: [
        DetailsLoading(),
        DetailsError(message: NETWORK_FAILURE_MESSAGE),
      ],
    );

    blocTest(
      'should emit [DetailsLoading], [DetailsLoaded] when search is successful',
      build: () async {
        when(mockGetMovieDetails(any))
            .thenAnswer((_) async => Right(movieDetailed));
        return bloc;
      },
      act: (bloc) => bloc.add(GetMovieDetailsEvent(id)),
      expect: [
        DetailsLoading(),
        DetailsLoaded(
          movieDetailed: movieDetailed,
        ),
      ],
    );
  });
}
