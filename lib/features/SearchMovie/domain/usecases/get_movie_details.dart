import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:movie_browser/core/error/failures.dart';
import 'package:movie_browser/core/usecases/usecase.dart';
import 'package:movie_browser/features/SearchMovie/domain/entities/movie_detailed_entity.dart';
import 'package:movie_browser/features/SearchMovie/domain/repositories/movie_search_repository.dart';

class GetMovieDetails extends UseCase<MovieDetailed, Params> {
  final MovieSearchRepository repository;

  GetMovieDetails(this.repository);

  Future<Either<Failure, MovieDetailed>> call(Params params) async {
    return await repository.getMovieDetails(params.id);
  }
}

class Params extends Equatable {
  final String id;

  Params({@required this.id});

  @override
  List<String> get props => [id];
}
