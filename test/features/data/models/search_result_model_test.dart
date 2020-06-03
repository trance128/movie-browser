import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_browser/features/SearchMovie/data/repositories/search_result_model.dart';
import 'package:movie_browser/features/SearchMovie/domain/entities/movie_brief_entity.dart';
import 'package:movie_browser/features/SearchMovie/domain/entities/search_result_entity.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  String title = "asdfjkl;";
  final searchResultModel =
      SearchResultModel(title: title, found: false, page: 1, totalResults: 0);

  test('should be a subclass of SearchResult entity', () {
    // assert
    expect(searchResultModel, isA<SearchResult>());
  });

  group('fromJson', () {
    test('should return a valid model from JSON when search fails', () async {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('search_result_failed.json'));

      final result = SearchResultModel.fromJson(title, jsonMap);

      expect(result, searchResultModel);
    });

    test('registers page as 1 and totalResults as 0 when search fails', () async {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('search_result_failed.json'));

      final result = SearchResultModel.fromJson(title, jsonMap);

      expect(result.page, 1);
      expect(result.totalResults, 0);
    });

    test('should return a valid model from JSON when search succeeds',
        () async {
      // arrange
      final String title = "asdf";
      final int page = 1;
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('search_result_by_title.json'));

      // act
      final result = SearchResultModel.fromJson(title, jsonMap);

      // assert
      final SearchResultModel expectedResult = SearchResultModel(
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

      expect(result, expectedResult);
    });

    test('correctly records page number as 1 when it\'s ommitted', () async {
      // arrange
      final String title = "asdf";
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('search_result_by_title.json'));

      // act
      final result = SearchResultModel.fromJson(title, jsonMap);

      // assert
      final SearchResultModel expectedResult = SearchResultModel(
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

      expect(result, expectedResult);
    });

    test('correctly records page number when it\'s given', () async {
      // arrange
      final String title = "asdf";
      final int page = 2;
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('search_result_by_title.json'));

      // act
      final result = SearchResultModel.fromJson(title, jsonMap, page);

      // assert
      final SearchResultModel expectedResult = SearchResultModel(
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

      expect(result, expectedResult);
    });

    test('handles results longer than 1 correctly', () async {
      // arrange
      final String title = "asdf";
      final int page = 2;
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('search_result_length_2.json'));

      // act
      final result = SearchResultModel.fromJson(title, jsonMap, page);

      // assert
      expect(result.results.length, 2);
    });

    test('registers all fields correctly', () async {
      // arrange
      final String title = "asdf";
      final int page = 2;
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('search_result_by_title.json'));

      // act
      final result = SearchResultModel.fromJson(title, jsonMap, page);

      // assert
      final SearchResultModel expectedResult = SearchResultModel(
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

      expect(result.title, expectedResult.title);
      expect(result.totalResults, expectedResult.totalResults);
      expect(result.page, expectedResult.page);
    });
  });
}
