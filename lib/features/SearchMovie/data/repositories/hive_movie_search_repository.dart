import 'package:hive/hive.dart';
import 'package:movie_browser/features/SearchMovie/data/datasources/movie_search_local_data_source.dart';
import 'package:movie_browser/features/SearchMovie/domain/entities/movie_detailed_entity.dart';
import 'package:movie_browser/features/SearchMovie/domain/entities/search_result_entity.dart';

abstract class HiveMovieSearchRepoAbstract extends MovieSearchLocalDataSource {
  Future<void> cacheMovieDetails(MovieDetailed movie);
  Future<MovieDetailed> getCachedMovieDetails(String id);

  Future<void> cacheSearch(SearchResult searchToCache);
  Future<SearchResult> getCachedSearch(String title, [int page = 1]);
}

// const vars to prevent misspellings
const String MOVIEDETAILSBOX = "MovieDetailedBox";
const String SEARCHBOX = "SearchBox";

class HiveMovieSearchRepo extends MovieSearchLocalDataSource implements HiveMovieSearchRepoAbstract {
  Box movieDetailsBox = Hive.box(MOVIEDETAILSBOX) ?? null;
  Box searchBox = Hive.box(SEARCHBOX);

  Future<void> cacheMovieDetails(MovieDetailed movie) async {
    /// expects a MovieDetailed to cache.  Will cache that movie
    movieDetailsBox ?? await _openBox(movieDetailsBox, MOVIEDETAILSBOX);

    movieDetailsBox.put('${movie.id}', movie);
  }

  Future<MovieDetailed> getCachedMovieDetails(String id) async {
    /// expects a string id as input
    /// returns the MovieDetailed if cached previously
    /// returns null otherwise
    movieDetailsBox ?? await _openBox(movieDetailsBox, MOVIEDETAILSBOX);

    return await movieDetailsBox.get('$id');
  }

  Future<void> cacheSearch(SearchResult searchToCache) async {
    /// expects a SearchResult as input, which will be cached
    searchBox ?? await _openBox(searchBox, SEARCHBOX);

    searchBox.put('T-${searchToCache.title}::P-${searchToCache.page}', searchToCache);
  }

  Future<SearchResult> getCachedSearch(String title, [int page = 1]) async {
    searchBox ?? await _openBox(searchBox, SEARCHBOX);

    return searchBox.get('T-$title::P-$page');
  }

  _openBox(Box box, String type) async {
    await Hive.openBox(type);
    return Hive.box(type);
  }
}