import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_browser/core/platform/network_info.dart';
import 'package:movie_browser/features/SearchMovie/data/datasources/movie_search_local_data_source.dart';
import 'package:movie_browser/features/SearchMovie/data/datasources/movie_search_remote_data_source.dart';
import 'package:movie_browser/features/SearchMovie/data/repositories/movie_search_repository_impl.dart';

class MockRemoteDataSource extends Mock implements MovieSearchRemoteDataSource{}

class MockLocalDataSource extends Mock implements MovieSearchLocalDataSource{}

class MockNetworkInfo extends Mock implements NetworkInfo{}

void main() {
  MovieSearchRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp((){
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = MovieSearchRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });
}