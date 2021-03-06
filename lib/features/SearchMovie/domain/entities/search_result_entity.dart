import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../data/models/movie_brief_hive_model.dart';

class SearchResult extends Equatable {
  /// SearchResults
  /// Represents the result of a search
  /// used for caching + pagination
  ///
  /// If no results found, totalResults must be set to 0 and page to 1

  final String title;
  final bool found;
  final int page;
  final int totalResults;
  final List<MovieBriefHive> results;

  SearchResult({
    @required this.title,
    @required this.found,
    @required this.page,
    @required this.totalResults,
    this.results,
  });

  @override
  List<Object> get props => [title, page, found, totalResults, results];
}
