import 'package:movie_browser/features/SearchMovie/domain/entities/movie_detailed_entity.dart';
import 'package:movie_browser/features/SearchMovie/domain/entities/search_result_entity.dart';

abstract class MovieSearchLocalDataSource {
  // loads a previous [SearchResult] from cache
  // returns null if no relevnt data found
  // throws [NoLocalDataException] if no cached data present;  
  Future<SearchResult> getPreviousSearch(String title, [int page = 1]);

  // caches data
  Future<void> cacheSearch(SearchResult searchToCache);

  // loads a previously searched [MovieDetailed] from cache
  // returns null if no relevant data found
  // throws [NoLocalDataException] if no cached data present
  Future<MovieDetailed> getCachedMovieDetails(String id);

  Future<void> cacheMovieDetails(MovieDetailed movieToCache);
}