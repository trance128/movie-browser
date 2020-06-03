import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/search_result.dart';
import '../repositories/movie_search_repository.dart';

class SearchMovie extends UseCase<SearchResult, Params> {
  final MovieSearchRepository repository;

  SearchMovie(this.repository);

  // gets the data from repository
  Future<Either<Failure, SearchResult>> call(Params params) async {
    return await repository.searchMovie(params.title, params.page);
  }
}

class Params extends Equatable {
  final String title;
  final int page;

  Params({@required this.title, this.page = 1});

  @override
  List<Object> get props => [title, page];
}
