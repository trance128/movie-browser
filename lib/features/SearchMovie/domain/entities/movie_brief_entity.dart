import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class MovieBrief extends Equatable {
  /// Movie brief entity
  /// Contains only essential movie data
  /// Used as initial search result
  /// 
  /// id is the same as imdbID
  /// year must be int
  
  final String id;
  final String title;
  final int year;
  final String poster;

  MovieBrief({
    @required this.id,
    @required this.title,
    @required this.year,
    this.poster,
  });

  @override
  List<String> get props => [id];
}
