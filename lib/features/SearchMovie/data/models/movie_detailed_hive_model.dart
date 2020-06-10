import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

import 'movie_detailed_model.dart';

part 'movie_detailed_hive_model.g.dart';

@HiveType(typeId: 1)
class MovieDetailedHive extends MovieDetailedModel {
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
}
