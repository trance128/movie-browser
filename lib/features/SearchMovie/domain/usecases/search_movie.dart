import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:movie_browser/core/error/failures.dart';
import 'package:movie_browser/features/SearchMovie/domain/entities/search_result.dart';
import 'package:movie_browser/features/SearchMovie/domain/repositories/movie_search_repository.dart';

class SearchMovie {
  final MovieSearchRepository repository;

  SearchMovie(this.repository);

  Future<Either<Failure, SearchResult>> execute(
      {@required String title, int page = 1}) async {
    return await repository.searchMovie(title, page);
  }
}
