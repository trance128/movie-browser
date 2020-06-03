import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class MovieDetailed extends Equatable {
  /// Detailed Movie entity
  /// contains all data in movie brief + more
  /// 
  /// id is the same the imdbID
  /// runtime must be int, representing total minutes
  /// year must be int

  final String id;
  final String title;
  final int year;
  final String poster;
  final String plot;
  final String rated;
  final DateTime released;
  final int runTime;
  final String genre;
  final String director;
  final String writer;
  final String actors;
  final String language;
  final String awards;
  final double rating;

  MovieDetailed({
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
  });

  @override 
  List<String> get props => [id];
}
