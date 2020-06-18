import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/movie_brief_entity.dart';
import '../../domain/entities/search_result_entity.dart';
import 'movie_brief_hive_model.dart';

part 'search_result_hive_model.g.dart';

@HiveType(typeId: 0)
class SearchHive extends SearchResult {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final bool found;
  @HiveField(2)
  final int page;
  @HiveField(3)
  final int totalResults;
  @HiveField(4)
  final List<MovieBriefHive> results;

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

  factory SearchHive.fromJson(
    String title,
    Map<String, dynamic> json, [
    int page = 1,
  ]) {
    // create SearchResult if the json didn't return any items
    // if json is null, or field not found, false is returned
    if ((json['Response'] ??= "False") == "False") {
      return SearchHive(
        title: title,
        found: false,
        page: 1,
        totalResults: 0,
      );
    }

    return _createSearchResultModel(title, json, page);
  }
}

SearchHive _createSearchResultModel(String title, Map<String, dynamic> json,
    [int page = 1]) {
  /// creates the searchresult model
  /// This function uses http://www.omdbapi.com/ json response
  /// To use a different api, modify this function

  List<MovieBriefHive> results = [];

  for (var result in json["Search"]) {
    results.add(MovieBriefHive(
      id: result['imdbID'],
      title: result['Title'],
      year: int.parse(result['Year']),
      poster: result['Poster'],
    ));
  }

  return SearchHive(
    title: title,
    found: true,
    page: page,
    totalResults: int.parse(json['totalResults']),
    results: results,
  );
}
