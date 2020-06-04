import '../../domain/entities/movie_detailed_entity.dart';
import '../../domain/entities/search_result_entity.dart';

abstract class MovieSearchRemoteDataSource {
  // searh for a movie from the http://www.omdbapi.com/?s= endpoint
  // throws a [ServerException] for server errors, and [CacheException]
  // for failure to load from local db
  Future<SearchResult> searchMovie(String title, [int page = 1]);

  // gets movie details from the http://www.omdbapi.com/?i= endpoint
  // throws a [SeverException] for errors from server, [CacheException]
  // for failure to load from local db
  Future<MovieDetailed> getMovieDetails(String id);
}