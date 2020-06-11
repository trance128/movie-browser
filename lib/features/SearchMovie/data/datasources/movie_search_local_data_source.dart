import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:movie_browser/features/SearchMovie/data/repositories/hive_repository.dart';

import '../../domain/entities/movie_detailed_entity.dart';
import '../../domain/entities/search_result_entity.dart';

abstract class MovieSearchLocalDataSource {
  // loads a previous [SearchResult] from cache
  // returns null if no relevnt data found
  // throws [NoLocalDataException] if no cached data present;  
  Future<SearchResult> getCachedSearch(String title, [int page = 1]);

  // caches data
  Future<void> cacheSearch(SearchResult searchToCache);

  // loads a previously searched [MovieDetailed] from cache
  // returns null if no relevant data found
  // throws [NoLocalDataException] if no cached data present
  Future<MovieDetailed> getCachedMovieDetails(String id);

  Future<void> cacheMovieDetails(MovieDetailed movieToCache);
}

class MovieSearchLocalDataSourceImpl implements MovieSearchLocalDataSource {
  final HiveRepository<MovieDetailed> hiveMovieRepo;

  // we'll need a second repo for search 
  MovieSearchLocalDataSourceImpl({this.hiveMovieRepo});

  @override
  Future<MovieDetailed> getCachedMovieDetails(String id) {

  }

  @override
  Future<void> cacheMovieDetails(MovieDetailed movieToCache) {

  }
}