import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_browser/features/SearchMovie/data/models/movie_detailed_model.dart';
import 'package:movie_browser/features/SearchMovie/domain/entities/movie_detailed_entity.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  String id = "1";
  String title = "hello world";
  int year = 2020;
  final movieDetailsModel =
      MovieDetailedModel(id: id, title: title, year: year);

  // expected values for details_search_complete fixture
  final completeMovieDetailedModel = MovieDetailedModel(
    id: "3",
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

  MovieDetailedModel _getMovieFromJson(String path) {
    /// returns the MovieDetailedModel from given json fixture
    Map<String, dynamic> jsonMap = json.decode(fixture(path));
    return MovieDetailedModel.fromJson(jsonMap);
  }

  group('fromJson', () {
    group('uses details_search_result fixture', () {
      final result = _getMovieFromJson('details_search_result.json');

      test('should be a subclass of ModeDetails entity', () {
        expect(result, isA<MovieDetailed>());
      });

      test('should return a valid model from only required params', () {
        // assert
        expect(result, movieDetailsModel);
      });
    });

    group('uses complete json data', () {
      final result = _getMovieFromJson('details_search_complete.json');
      test('should return a valid model when all params are passed', () {
        // assert
        expect(result, completeMovieDetailedModel);
      });

      test(
          'fields that don\'t require conversion are correclty registered when they\'re present',
          () {
        expect(result.poster, completeMovieDetailedModel.poster);
        expect(result.plot, completeMovieDetailedModel.plot);
        expect(result.rated, completeMovieDetailedModel.rated);
        expect(result.genre, completeMovieDetailedModel.genre);
        expect(result.director, completeMovieDetailedModel.director);
        expect(result.writer, completeMovieDetailedModel.writer);
        expect(result.actors, completeMovieDetailedModel.actors);
        expect(result.language, completeMovieDetailedModel.language);
        expect(result.awards, completeMovieDetailedModel.awards);
      });

      test('runtime converted to int and holds correct value', () {
        expect(result.runTime, isA<int>());
        expect(result.runTime, 121);
      });

      test('ratings is correctly calculated when all fields are present', () {
        expect(result.rating, 88);
      });
    });

    group('json data contains N/A fields', () {
      final result = _getMovieFromJson('details_search_null.json');

      test('when json contains n/a values, they\'re registers as null',
          () async {
        expect(result.runTime, isNull);
        expect(result.poster, isNull);
        expect(result.plot, isNull);
        expect(result.rated, isNull);
        expect(result.writer, isNull);
        expect(result.awards, isNull);
        expect(result.rating, isNull);
      });

      test('year is converted to int', () {
        expect(result.year, isA<int>());
        expect(result.year, 2016);
      });

      test('released converted to DateTime and holds correct value', () {
        expect(result.released, isA<DateTime>());
        expect(result.released, DateTime.parse('2016-01-03 00:00:00.000'));
      });

      test('Rating is null if there are no ratings', () {
        expect(result.rating, isNull);
      });
    });

    test('year is recorded as 0 if there\'s a format error', () {
      // it shouldn't be possible for the year to have a format error, but we'll cover
      // it just in case
      Map<String, dynamic> jsonMap = {
        "imdbID": "1",
        "Title": "Year error",
        "Year": "Isn't correct"
      };

      final result = MovieDetailedModel.fromJson(jsonMap);

      expect(result.year, 0);
    });

    test('runtime successfully converted if json uses hours, not minutes', () {
      final result = _getMovieFromJson('details_search_hours.json');

      expect(result.runTime, isA<int>());
      expect(result.runTime, 120);
    });
  });
}
