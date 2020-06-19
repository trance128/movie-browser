import 'package:hive/hive.dart';

import '../../data/models/search_result_hive_model.dart';
import '../../domain/entities/movie_detailed_entity.dart';
import '../datasources/movie_search_local_data_source.dart';

abstract class HiveMovieSearchRepoAbstract extends MovieSearchLocalDataSource {
  Future<void> cacheMovieDetails(MovieDetailed movie);
  Future<MovieDetailed> getCachedMovieDetails(String id);

  Future<void> cacheSearch(SearchHive searchToCache);
  Future<SearchHive> getCachedSearch(String title, [int page = 1]);
}

// const vars to prevent misspellings
const String MOVIEDETAILSBOX = "MovieDetailedBox";
const String SEARCHBOX = "SearchBox";

class HiveMovieSearchRepo extends MovieSearchLocalDataSource
    implements HiveMovieSearchRepoAbstract {
  Box movieDetailsBox;
  Box searchBox;

  Future<void> cacheMovieDetails(MovieDetailed movie) async {
    /// expects a MovieDetailed to cache.  Will cache that movie
    if (movieDetailsBox == null)
      movieDetailsBox = await _openBox(movieDetailsBox, MOVIEDETAILSBOX);

    movieDetailsBox.put('${movie.id}', movie);
  }

  Future<MovieDetailed> getCachedMovieDetails(String id) async {
    /// expects a string id as input
    /// returns the MovieDetailed if cached previously
    /// returns null otherwise
    if (movieDetailsBox == null)
      movieDetailsBox = await _openBox(searchBox, MOVIEDETAILSBOX);

    return await movieDetailsBox.get('$id');
  }

  Future<void> cacheSearch(SearchHive searchToCache) async {
    /// expects a SearchResult as input, which will be cached
    if (searchBox == null) searchBox = await _openBox(searchBox, SEARCHBOX);

    searchBox.put(
        'T-${searchToCache.title}::P-${searchToCache.page}', searchToCache);
  }

  Future<SearchHive> getCachedSearch(String title, [int page = 1]) async {
    // searchBox ?? await _openBox(searchBox, SEARCHBOX);
    if (searchBox == null) searchBox = await _openBox(searchBox, SEARCHBOX);

    return searchBox.get('T-$title::P-$page');
  }

  _openBox(Box box, String type) async {
    await Hive.openBox(type);
    return Hive.box(type);
  }
}
