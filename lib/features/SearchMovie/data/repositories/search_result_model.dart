import 'package:meta/meta.dart';

import '../../domain/entities/movie_brief_entity.dart';
import '../../domain/entities/search_result_entity.dart';

class SearchResultModel extends SearchResult {
  SearchResultModel({
    @required String title,
    @required bool found,
    @required int page,
    @required int totalResults,
    List<MovieBrief> results,
  }) : super(
          title: title,
          found: found,
          page: page,
          totalResults: totalResults,
          results: results,
        );

  factory SearchResultModel.fromJson(
    String title,
    Map<String, dynamic> json, [
    int page = 1,
  ]) {
    // create SearchResult if the json didn't return any items
    // if json is null, or field not found, false is returned
    if ((json['Response'] ??= "False") == "False") {
      return SearchResultModel(
        title: title,
        found: false,
        page: 1,
        totalResults: 0,
      );
    }

    return _createSearchResultModel(title, json, page);
  }
}

SearchResultModel _createSearchResultModel(
    String title, Map<String, dynamic> json,
    [int page = 1]) {
  /// creates the searchresult model
  /// This function uses http://www.omdbapi.com/ json response
  /// To use a different api, modify this function

  List<MovieBrief> results = [];

  for (var result in json["Search"]) {
    results.add(MovieBrief(
      id: result['imdbID'],
      title: result['Title'],
      year: int.parse(result['Year']),
      poster: result['Poster'],
    ));
  }

  return SearchResultModel(
    title: title,
    found: true,
    page: page,
    totalResults: int.parse(json['totalResults']),
    results: results,
  );
}
