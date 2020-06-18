import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_browser/core/error/exception.dart';
import 'package:movie_browser/core/error/failures.dart';
import 'package:movie_browser/core/network/network_info.dart';
import 'package:movie_browser/features/SearchMovie/data/datasources/movie_search_local_data_source.dart';
import 'package:movie_browser/features/SearchMovie/data/datasources/movie_search_remote_data_source.dart';
import 'package:movie_browser/features/SearchMovie/data/models/movie_detailed_hive_model.dart';
import 'package:movie_browser/features/SearchMovie/data/models/search_result_hive_model.dart';
import 'package:movie_browser/features/SearchMovie/data/repositories/movie_search_repository_impl.dart';
import 'package:movie_browser/features/SearchMovie/domain/entities/search_result_entity.dart';

class MockRemoteDataSource extends Mock implements MovieSearchRemoteDataSource {
}

class MockLocalDataSource extends Mock implements MovieSearchLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MovieSearchRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = MovieSearchRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('searchMovie', () {
    final String title = "Ovidius";
    final int page = 3;
    final int totalResults = 32;
    final SearchHive searchHive = SearchHive(
      title: title,
      page: page,
      totalResults: totalResults,
      found: true,
      results: [],
    );
    final SearchResult searchResult = searchHive;

    group('search result is not in localdata & have network connection', () {
      setUp(() {
        when(mockLocalDataSource.getCachedSearch(title, page))
            .thenThrow(CacheException());
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should return remote data when call to remote data is successful',
          () async {
        when(mockRemoteDataSource.searchMovie(title, page))
            .thenAnswer((_) async => searchHive);

        final result = await repository.searchMovie(title, page);

        verify(mockRemoteDataSource.searchMovie(title, page));
        expect(result, equals(Right(searchHive)));
      });

      test('should cache the data locally when remote search is successful',
          () async {
        when(mockRemoteDataSource.searchMovie(title, page))
            .thenAnswer((_) async => searchHive);

        await repository.searchMovie(title, page);

        verify(mockRemoteDataSource.searchMovie(title, page));
        verify(mockLocalDataSource.cacheSearch(searchResult));
      });

      test('should return server failure when call to remote data source fails',
          () async {
        when(mockRemoteDataSource.searchMovie(title, page))
            .thenThrow(ServerException());

        final result = await repository.searchMovie(title, page);

        verify(mockRemoteDataSource.searchMovie(title, page));
        expect(result, equals(Left(ServerFailure())));
      });


    });

    test('should return NetworkFailure when we have no local data and no network connectection', () async {
      when(mockLocalDataSource.getCachedSearch(title, page)).thenThrow(CacheException());
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.searchMovie(title, page);

      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockNetworkInfo.isConnected);
      expect(result, equals(Left(NetworkFailure())));
    });

    group('search result is in localdata', () {
      test('should return locally cached data', () async {
        when(mockLocalDataSource.getCachedSearch(title, page))
            .thenAnswer((_) async => SearchHive);

        final result = await repository.searchMovie(title, page);

        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getCachedSearch(title, page));
        expect(result, equals(Right(searchResult)));
      });
    });
  });

  group('getMovieDetails', () {
    final String id = "tt1";
    final String title = "Ovidius";
    final int year = 2020;
    final MovieDetailedHive movieDetailed = MovieDetailedHive(
      id: id,
      title: title,
      year: year,
    );

    group('localData is present', () {
      setUp(() async {
        when(mockLocalDataSource.getCachedMovieDetails(id))
            .thenAnswer((_) async => movieDetailed);
      });

      test('should return locally cached data', () async {
        final result = await repository.getMovieDetails(id);

        verifyZeroInteractions(mockRemoteDataSource);
        verifyZeroInteractions(mockNetworkInfo);
        verify(mockLocalDataSource.getCachedMovieDetails(id));
        expect(result, equals(Right(movieDetailed)));
      });
    });

    group('No localData found, has network connection', () {
      setUp(() async {
        when(mockLocalDataSource.getCachedMovieDetails(id))
            .thenThrow(CacheException());
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should return remote data when no localdata present', () async {
        when(mockRemoteDataSource.getMovieDetails(id))
            .thenAnswer((_) async => movieDetailed);

        final result = await repository.getMovieDetails(id);

        verify(mockRemoteDataSource.getMovieDetails(id));
        expect(result, Right(movieDetailed));
      });

      test('should cache the data locally when remote search is successful',
          () async {
        when(mockRemoteDataSource.getMovieDetails(id))
            .thenAnswer((_) async => movieDetailed);

        await repository.getMovieDetails(id);

        verify(mockRemoteDataSource.getMovieDetails(id));
        verify(mockLocalDataSource.cacheMovieDetails(movieDetailed));
      });

      test('should return server failure when call to remote data source fails',
          () async {
        when(mockRemoteDataSource.getMovieDetails(id))
            .thenThrow(ServerException());

        final result = await repository.getMovieDetails(id);

        verify(mockRemoteDataSource.getMovieDetails(id));
        expect(result, equals(Left(ServerFailure())));
      });
    });

    test(
        'should return Left Network Failure if we have no localdata and no network connection',
        () async {
      when(mockLocalDataSource.getCachedMovieDetails(id))
          .thenThrow(CacheException());
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.getMovieDetails(id);

      verify(mockNetworkInfo.isConnected);
      expect(result, Left(NetworkFailure()));
    });
  });
}
