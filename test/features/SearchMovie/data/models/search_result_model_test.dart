import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_browser/features/SearchMovie/data/models/movie_brief_hive_model.dart';
import 'package:movie_browser/features/SearchMovie/data/models/search_result_hive_model.dart';
import 'package:movie_browser/features/SearchMovie/domain/entities/search_result_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final String title = "asdf";
  final int page = 1;
  final int secondPage = 2;
  final SearchHive searchHive =
      SearchHive(title: title, found: false, page: page, totalResults: 0);

  Map<String, dynamic> _getJson(String path) {
    /// returns the decoded json from a specified fixture's path
    return json.decode(fixture(path));
  }

  final SearchHive expectedSingleResult = SearchHive(
    title: title,
    page: page,
    found: true,
    totalResults: 1,
    results: [
      MovieBriefHive(
        id: "1",
        title: title,
        year: 2018,
        poster:
            "https://m.media-amazon.com/images/M/MV5BOTM2NTI3NTc3Nl5BMl5BanBnXkFtZTgwNzM1OTQyNTM@._V1_SX300.jpg",
      )
    ],
  );

  test('should be a subclass of SearchResult entity', () {
    // assert
    expect(SearchHive, isA<SearchResult>());
  });

  group('fromJson', () {
    test('should return a valid model from JSON when search fails', () async {
      final jsonMap = _getJson('search_result_failed.json');

      final result = SearchHive.fromJson(title, jsonMap);

      expect(result, searchHive);
    });

    test('registers page as 1 and totalResults as 0 when search fails',
        () async {
      final jsonMap = _getJson('search_result_failed.json');

      final result = SearchHive.fromJson(title, jsonMap);

      expect(result.page, 1);
      expect(result.totalResults, 0);
    });

    test('should return a valid model from JSON when search succeeds',
        () async {
      // arrange
      final jsonMap = _getJson('search_result_by_title.json');

      // act
      final result = SearchHive.fromJson(title, jsonMap);

      // assert

      expect(result, expectedSingleResult);
    });

    test('correctly records page number as 1 when it\'s ommitted', () async {
      // arrange
      final String title = "asdf";
      final jsonMap = _getJson('search_result_by_title.json');

      // act
      final result = SearchHive.fromJson(title, jsonMap);

      // assert
      expect(result, expectedSingleResult);
    });

    test('correctly records page number when it\'s explicitly given', () async {
      // arrange
      final jsonMap = _getJson('search_result_by_title.json');

      // act
      final result = SearchHive.fromJson(title, jsonMap, secondPage);

      // assert
      // assert
      final SearchHive expectedResult = SearchHive(
        title: title,
        page: secondPage,
        found: true,
        totalResults: 1,
        results: [
          MovieBriefHive(
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
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('search_result_length_2.json'));

      // act
      final result = SearchHive.fromJson(title, jsonMap, page);

      // assert
      expect(result.results.length, 2);
    });

    test('registers all fields correctly', () async {
      // arrange
      final jsonMap = _getJson('search_result_by_title.json');
      final overwrittenTitle = "Hello Again, World";

      // act
      final result = SearchHive.fromJson(overwrittenTitle, jsonMap, secondPage);

      // assert
      final SearchHive expectedResult = SearchHive(
        title: overwrittenTitle,
        page: secondPage,
        found: true,
        totalResults: 1,
        results: [
          MovieBriefHive(
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
