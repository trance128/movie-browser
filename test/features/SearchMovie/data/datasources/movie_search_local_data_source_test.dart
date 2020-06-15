import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_browser/core/error/exception.dart';
import 'package:movie_browser/features/SearchMovie/data/datasources/movie_search_local_data_source.dart';
import 'package:movie_browser/features/SearchMovie/data/models/movie_detailed_model.dart';
import 'package:movie_browser/features/SearchMovie/data/models/search_result_model.dart';
import 'package:movie_browser/features/SearchMovie/data/repositories/hive_movie_search_repository.dart';
import 'package:movie_browser/features/SearchMovie/domain/entities/movie_brief_entity.dart';

class MockHiveMovieSearchRepo extends Mock implements HiveMovieSearchRepo {}

void main() {
  MovieSearchLocalDataSourceImpl dataSource;
  MockHiveMovieSearchRepo mockHiveMovieSearchRepo;

  setUp(() {
    mockHiveMovieSearchRepo = MockHiveMovieSearchRepo();
    dataSource = MovieSearchLocalDataSourceImpl(
      hiveMovieSearchRepo: mockHiveMovieSearchRepo,
    );
  });

  group('MovieDetailed', () {
    String id = "3";
    final movieModel = MovieDetailedModel(
      id: id,
      title: "Hello World Once More",
      year: 1977,
      poster:
          "https://m.media-amazon.com/images/M/MV5BNzVlY2MwMjktM2E4OS00Y2Y3LWE3ZjctYzhkZGM3YzA1ZWM2XkEyXkFqcGdeQXVyNzkwMjQ5NzM@._V1_SX300.jpg",
      plot:
          "Luke Skywalker joins forces with a Jedi Knight, a cocky pilot, a Wookiee and two droids to save the galaxy from the Empire's world-destroying battle station, while also attempting to rescue Princess Leia from the mysterious Darth Vader.",
      rated: "PG",
      released: DateTime.parse('1977-05-25 00:00:00.000'),
      runTime: 121,
      genre: "Action, Adventure, Fantasy, Sci-Fi",
      director: "George Lucas",
      writer: "George Lucas",
      actors: "Mark Hamill, Harrison Ford, Carrie Fisher, Peter Cushing",
      language: "English",
      awards: "Won 6 Oscars. Another 52 wins & 28 nominations.",
      rating: 90,
    );

    test('should return MovieDetailed from Hive when there is one in Cache',
        () async {
      when(mockHiveMovieSearchRepo.getCachedMovieDetails(id))
          .thenAnswer((_) async => movieModel);

      final result = await dataSource.getCachedMovieDetails(id);

      verify(mockHiveMovieSearchRepo.getCachedMovieDetails(id));
      expect(result, movieModel);
    });

    test('should throw a CachedException when there is no cahced data',
        () async {
      when(mockHiveMovieSearchRepo.getCachedMovieDetails(id)).thenAnswer((_) async => null);

      // need to call like this to test exception
      expect(() => dataSource.getCachedMovieDetails(id),
          throwsA(isInstanceOf<CacheException>()));
    });

    test('should call HiveRepo to cache data', () {
      dataSource.cacheMovieDetails(movieModel);

      verify(mockHiveMovieSearchRepo.cacheMovieDetails(movieModel));
    });
  });

  group('SearchResult', () {
    final String title = "Hello World";
    final page = 3;
    final SearchResultModel searchResult = SearchResultModel(
      title: title,
      page: page,
      found: true,
      totalResults: 1,
      results: [
        MovieBrief(
          id: "1",
          title: title,
          year: 2018,
          poster:
              "https://m.media-amazon.com/images/M/MV5BOTM2NTI3NTc3Nl5BMl5BanBnXkFtZTgwNzM1OTQyNTM@._V1_SX300.jpg",
        )
      ],
    );

    test('should return a SearchResult object when there is one in Cache',
        () async {
      when(mockHiveMovieSearchRepo.getCachedSearch(title, page))
          .thenAnswer((_) async => searchResult);

      final result = await dataSource.getCachedSearch(title, page);

      verify(mockHiveMovieSearchRepo.getCachedSearch(title, page));
      expect(result, searchResult);
    });

    test('correctly infers page = 1 when not specified', () async {
      final SearchResultModel searchResultP1 = SearchResultModel(
        title: title,
        page: 1,
        found: true,
        totalResults: 1,
        results: [
          MovieBrief(
            id: "1",
            title: title,
            year: 2018,
            poster:
                "https://m.media-amazon.com/images/M/MV5BOTM2NTI3NTc3Nl5BMl5BanBnXkFtZTgwNzM1OTQyNTM@._V1_SX300.jpg",
          )
        ],
      );

      when(mockHiveMovieSearchRepo.getCachedSearch(title)).thenAnswer((_) async => searchResultP1);

      final result = await dataSource.getCachedSearch(title);

      expect(result, searchResultP1);
    });

    test('should return [CacheError] when hiverepo returns null', () {
      when(mockHiveMovieSearchRepo.getCachedSearch(title)).thenAnswer((_) async => null);

      expect(() => dataSource.getCachedSearch(title), throwsA(isInstanceOf<CacheException>()));
    });

    test('should call hive repo to cache data', () {
      dataSource.cacheSearch(searchResult);

      verify(mockHiveMovieSearchRepo.cacheSearch(searchResult));
    });
  });
}
