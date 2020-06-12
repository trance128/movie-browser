import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:movie_browser/core/error/exception.dart';
import 'package:movie_browser/features/SearchMovie/data/models/search_result_model.dart';

import '../../../../api_key.dart';
import '../../domain/entities/movie_detailed_entity.dart';
import '../../domain/entities/search_result_entity.dart';
import '../models/movie_detailed_model.dart';

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

// const urls
const String BASE_URL = "http://www.omdbapi.com/?apikey=$apiKey&";
const String BASE_URL_ID = "${BASE_URL}i=";

class MovieSearchRemoteDataSourceImpl extends MovieSearchRemoteDataSource {
  final http.Client client;

  MovieSearchRemoteDataSourceImpl({@required this.client});

  Future<MovieDetailedModel> getMovieDetails(String id) async {
    /// expects a [String] id, representing the imdbID of a movie.  This id
    /// is saved as id in both [MovieBrief] and [MovieDetailed]
    /// returns a [MovieDetailed] object, or [ServerException] in case of failure

    final response = await client.get('$BASE_URL_ID$id');

    if (response.statusCode != 200) throw ServerException();

    return MovieDetailedModel.fromJson(json.decode(response.body));
  }

  Future<SearchResult> searchMovie(String title, [int page = 1]) async {
    /// expects a [String] title to search, and an optional [int] page
    /// returns a [SearchResult], with a list results of up to 10 [MovieBrief] objects.
    /// throws [ServerException] in case of failure

    final response = await client.get(_buildSearchUrl(title, page));

    if (response.statusCode != 200) throw ServerException();

    return SearchResultModel.fromJson(title, json.decode(response.body), page);
  }

  String _buildSearchUrl(String title, int page) {
    /// helper method to build search url
    String returnString = '${BASE_URL}s=$title';
    if (page != 1) returnString += '&page=$page';
    return returnString;
  }
}
