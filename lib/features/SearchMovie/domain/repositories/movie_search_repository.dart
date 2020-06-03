import 'package:dartz/dartz.dart';
import 'package:movie_browser/core/error/failures.dart';
import 'package:movie_browser/features/SearchMovie/domain/entities/search_result.dart';

abstract class MovieSearchRepository {
  Future<Either<Failure, SearchResult>> searchMovie(String title, [int page = 1]);
  Future<Either<Failure, SearchResult>> getMovieDetails(String id);
}