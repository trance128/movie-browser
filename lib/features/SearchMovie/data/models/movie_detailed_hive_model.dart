import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:movie_browser/core/helpers/helpers.dart';
import '../../domain/entities/movie_detailed_entity.dart';

part 'movie_detailed_hive_model.g.dart';

@HiveType(typeId: 1)
class MovieDetailedHive extends MovieDetailed {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final int year;
  @HiveField(3)
  final String poster;
  @HiveField(4)
  final String plot;
  @HiveField(5)
  final String rated;
  @HiveField(6)
  final DateTime released;
  @HiveField(7)
  final int runTime;
  @HiveField(8)
  final String genre;
  @HiveField(9)
  final String director;
  @HiveField(10)
  final String writer;
  @HiveField(11)
  final String actors;
  @HiveField(12)
  final String language;
  @HiveField(13)
  final String awards;
  @HiveField(14)
  final int rating;

  MovieDetailedHive({
    @required this.id,
    @required this.title,
    @required this.year,
    this.poster,
    this.plot,
    this.rated,
    this.released,
    this.runTime,
    this.genre,
    this.director,
    this.writer,
    this.actors,
    this.language,
    this.awards,
    this.rating,
  }) : super(
          id: id,
          title: title,
          year: year,
          poster: poster,
          plot: plot,
          rated: rated,
          released: released,
          runTime: runTime,
          genre: genre,
          director: director,
          writer: writer,
          actors: actors,
          language: language,
          awards: awards,
          rating: rating,
        );

  factory MovieDetailedHive.fromJson(Map<String, dynamic> json) {
    return _getMovieDetailedModel(json);
  }
}

MovieDetailedHive _getMovieDetailedModel(Map<String, dynamic> json) {
  /// this function made specifically for http://www.omdbapi.com/ json response
  /// modify this function to use different api

  // We only want the initial release year, so in the case of a series,
  // which might have year as 2012 - 2018, we only use that first number
  // returns 0 in case something goes really wrong
  int year;
  try {
    if (json['Year'].length > 4) {
      year = int.parse(json['Year'].substring(0, 4));
    } else {
      year = int.parse(json['Year']);
    }
  } catch (e) {
    year = 0;
  }

  return MovieDetailedHive(
    id: json['imdbID'],
    title: _getValueOrNull(json['Title']),
    year: year,
    poster: _getValueOrNull(json['Poster']),
    plot: _getValueOrNull(json['Plot']),
    rated: _getValueOrNull(json['Rated']),
    released: _formatDate(json['Released']),
    runTime: _convertRunTime(json['Runtime']),
    genre: _getValueOrNull(json['Genre']),
    director: _getValueOrNull(json['Director']),
    writer: _getValueOrNull(json['Writer']),
    actors: _getValueOrNull(json['Actors']),
    language: _getValueOrNull(json['Language']),
    awards: _getValueOrNull(json['Awards']),
    rating: _buildAverageRating(json),
  );
}

String _getValueOrNull(String string) {
  return string == 'N/A' ? null : string;
}

DateTime _formatDate(String string) {
  /// works specifically with format used by http://www.omdbapi.com/

  return string == 'N/A' || string == null
      ? null
      : DateFormat('d MMM y').parse(string);
}

int _convertRunTime(String s) {
  /// exepcts a string s, the format used by omdbapi.com to represent
  /// run time
  /// returns runTime as an int
  /// Format Expected -- "121 min", will also accept "2 hours"
  /// Funtion will break if any other format is used

  if (s == 'N/A' || s == null) return null;

  // create a string with just numeric values, until first non-numeric is found
  // then, return parsed int.  Corrects for min / hours
  String returnString = '';
  for (int i = 0; i < s.length; i++) {
    if (isNumeric(s[i])) {
      returnString += s[i];
    } else {
      if (s.substring(i + 1, i + 3) == 'mi') {
        return int.parse(returnString);
      } else {
        // if formatted as hours, multiply by 60
        assert(s[i + 1] == 'h');
        return int.parse(returnString) * 60;
      }
    }
  }

  return null;
}

int _buildAverageRating(Map<String, dynamic> json) {
  /// builds an average rating from the unorganized myraid of
  /// ratings omdbapi uses
  /// returns average rating, from 0 - 100
  /// Recognizes Internet Movie Database, Rotten Tomatoes, Metacritic
  /// Metascore and imdb ratings.  Any others will be ignored

  int total = 0;
  int ratings = 0;

  // ratings are formatted differently for each db
  if (json['Ratings'] != null) {
    for (var item in json['Ratings']) {
      // Internet Movie Databases uses format 8.6/10
      if (item['Source'] == 'Internet Movie Database') {
        if (item['Value'] == 'N/A') break;

        String returnString = '';

        for (int i = 0; i < item['Value'].length; i++) {
          if (item['Value'][i] == '/') {
            break;
          } else {
            returnString += item['Value'][i];
          }
        }

        total += double.parse(returnString) * 10 ~/ 1;
        ratings++;
      }
      // Rotten tomatoes uses format 92%
      else if (item['Source'] == "Rotten Tomatoes") {
        if (item['Value'] == 'N/A') break;
        // if 2nd digit is also numeric.  Otherwise, we have a percentage
        // under 10, like 9%.  That'd give us a format error when parsing
        if (isNumeric(item['Value'][1])) {
          total += int.parse(item['Value'].substring(0, 2));
        } else {
          total += int.parse(item['Value'][0]);
        }
        ratings++;
      }
      // Metacritic uses 90/100
      else if (item['Source'] == 'Metacritic') {
        if (item['Value'] == 'N/A') break;
        // accounts for possibility of 9/100 or similar rating
        if (isNumeric(item['Value'][1])) {
          total += int.parse(item['Value'].substring(0, 2));
        } else {
          total += int.parse(item['Value'][0]);
        }
        ratings++;
      }
    }
  }

  // Metascore uses format 90
  if (json['Metascore'] != 'N/A' && json['Metascore'] != null) {
    if (isNumeric(json['Metascore'][1])) {
      total += int.parse(json['Metascore'].substring(0, 2));
    } else {
      total += int.parse(json['Metascore'][0]);
    }
    ratings++;
  }

  // imdbRating uses format 8.6
  if (json['imdbRating'] != 'N/A' && json['imdbRating'] != null) {
    if (json['imdbRating'].length != 3) {
      total += int.parse(json['imdbRating'][0] * 10);
    } else {
      total += double.parse(json['imdbRating'].substring(0, 3)) * 10 ~/ 1;
    }
    ratings++;
  }

  if (ratings == 0) return null;

  return (total ~/ ratings);
}
