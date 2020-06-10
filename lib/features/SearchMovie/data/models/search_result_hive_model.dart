import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/movie_brief_entity.dart';
import 'search_result_model.dart';

part 'search_result_hive_model.g.dart';

@HiveType(typeId: 0)
class SearchHive extends SearchResultModel {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final bool found;
  @HiveField(2)
  final int page;
  @HiveField(3)
  final int totalResults;
  @HiveField(4)
  final List<MovieBrief> results;

  SearchHive({
    @required this.title,
    @required this.found,
    @required this.page,
    @required this.totalResults,
    this.results,
  }) : super(
    title: title,
    found: found,
    page: page,
    totalResults: totalResults,
    results: results,
  );
}