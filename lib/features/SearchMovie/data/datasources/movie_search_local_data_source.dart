import 'package:movie_browser/core/error/exception.dart';
import 'package:movie_browser/features/SearchMovie/data/repositories/hive_movie_search_repository.dart';

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
  final HiveMovieSearchRepo hiveMovieSearchRepo;

  MovieSearchLocalDataSourceImpl({this.hiveMovieSearchRepo});

  @override
  Future<MovieDetailed> getCachedMovieDetails(String id) async {
    /// expects a string id
    /// gets the MovieDetailed if previously cached, returns [CacheError]
    /// otherwise
    final movie = await hiveMovieSearchRepo.getCachedMovieDetails(id);
    
    if (movie == null) throw CacheException();
    return movie;
  }

  @override
  Future<void> cacheMovieDetails(MovieDetailed movieToCache) async {
    /// expects MovieDetailed object.  Caches that object
    return await hiveMovieSearchRepo.cacheMovieDetails(movieToCache);
  }

  @override 
  Future<SearchResult> getCachedSearch(String title, [int page = 1]) async {
    /// expects a String title, and option int page
    /// returns a SearchResult if previously cached
    /// throws [CacheException] otherwise
    final search = await hiveMovieSearchRepo.getCachedSearch(title, page);

    if (search == null) throw CacheException();
    return search;
  }

  @override 
  Future<void> cacheSearch(SearchResult searchToCache) async {
    /// expects a SearchResult object which will be cached
    return await hiveMovieSearchRepo.cacheSearch(searchToCache);
  }
}