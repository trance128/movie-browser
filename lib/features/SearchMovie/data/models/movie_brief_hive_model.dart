import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/movie_brief_entity.dart';

part 'movie_brief_hive_model.g.dart';

@HiveType(typeId: 2)
class MovieBriefHive extends MovieBrief {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final int year;
  @HiveField(3)
  final String poster;

  MovieBriefHive(
      {@required this.id,
      @required this.title,
      @required this.year,
      this.poster})
      : super(
          id: id,
          title: title,
          year: year,
          poster: poster,
        );
}
