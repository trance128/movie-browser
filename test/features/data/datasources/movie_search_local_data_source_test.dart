import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_browser/features/SearchMovie/data/datasources/movie_search_local_data_source.dart';
import 'package:movie_browser/features/SearchMovie/data/repositories/hive_repository.dart';
import 'package:movie_browser/features/SearchMovie/domain/entities/movie_detailed_entity.dart';

class MockHiveRepository<T> extends Mock implements HiveRepository<T>{}

void main() {
  MovieSearchLocalDataSourceImpl dataSource;
  MockHiveRepository<MovieDetailed> mockHiveMovieRepo;

  setUp(() {
    mockHiveMovieRepo = MockHiveRepository<MovieDetailed>();
    dataSource = MovieSearchLocalDataSourceImpl(hiveMovieRepo: mockHiveMovieRepo);
  });


}