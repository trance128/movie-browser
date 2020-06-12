import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:movie_browser/core/error/exception.dart';
import 'package:movie_browser/features/SearchMovie/data/datasources/movie_search_remote_data_source.dart';
import 'package:movie_browser/features/SearchMovie/data/models/movie_detailed_model.dart';
import 'package:movie_browser/features/SearchMovie/data/models/search_result_model.dart';
import 'package:movie_browser/features/SearchMovie/domain/entities/movie_detailed_entity.dart';
import 'package:movie_browser/features/SearchMovie/domain/entities/search_result_entity.dart';

import '../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  MovieSearchRemoteDataSourceImpl dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = MovieSearchRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('getMovieDetails', () {
    String id = "3";
    final expectedModel = MovieDetailedModel.fromJson(
        json.decode(fixture('details_search_complete.json')));

    test('should perform a GET request on a URL with id as the endpoint', () {
      when(mockHttpClient.get(any)).thenAnswer((_) async =>
          http.Response(fixture('details_search_complete.json'), 200));

      dataSource.getMovieDetails(id);

      verify(mockHttpClient.get('$BASE_URL_ID$id'));
    });

    test('should return MovieDetailed model when response is ok', () async {
      when(mockHttpClient.get(any)).thenAnswer((_) async =>
          http.Response(fixture('details_search_complete.json'), 200));

      final result = await dataSource.getMovieDetails(id);

      expect(result, isA<MovieDetailed>());
      expect(result, expectedModel);
    });

    test('should throw a [ServerException] when response code is not 200',
        () async {
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));

      final call = dataSource.getMovieDetails;

      expect(() => call(id), throwsA(isInstanceOf<ServerException>()));
    });
  });

  group('searchMovie', () {
    String title = "asdf";

    void setUpMockHttpClientSuccessSearch() {
      when(mockHttpClient.get(any)).thenAnswer((_) async =>
          http.Response(fixture('search_result_by_title.json'), 200));
    }

    // tests for private method _buildSearchUrl.  Commented out since
    // method is private, so can't test when live.  Make method public
    // to test

    // test('buildSearchUrl correctly builds url', () {
    //   final expectedStringPage1 = '${BASE_URL}s=$title';
    //   final expectedStringPage2 = '${BASE_URL}s=$title&page=2';

    //   final returnStringPage1 = dataSource.buildSearchUrl(title, 1);
    //   final returnStringPage2 = dataSource.buildSearchUrl(title, 2);

    //   expect(returnStringPage1, expectedStringPage1);
    //   expect(returnStringPage2, expectedStringPage2);
    // });

    test('should perform a http GET request with title and page as endpoints',
        () async {
      int page = 2;
      setUpMockHttpClientSuccessSearch();

      dataSource.searchMovie(title, page);

      verify(mockHttpClient.get('${BASE_URL}s=$title&page=$page'));
    });

    test('returns SearchResultModel when search is successful', () async {
      int page = 2;
      final expectedSearchResult = SearchResultModel.fromJson(title, json.decode(fixture('search_result_by_title.json')), page);
      setUpMockHttpClientSuccessSearch();

      final result = await dataSource.searchMovie(title, page);

      expect(result, isA<SearchResult>());
      expect(result, expectedSearchResult);
    });

    test('throws a ServerException when response code is not 200', () async {
      when(mockHttpClient.get(any)).thenAnswer((_) async => http.Response('Something went wrong', 4040));

      final call = dataSource.searchMovie;

      expect(() => call(title), throwsA(isInstanceOf<ServerException>()));
    });
  });
}
