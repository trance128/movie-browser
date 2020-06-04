import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/platform/network_info.dart';
import '../../domain/entities/movie_detailed_entity.dart';
import '../../domain/entities/search_result_entity.dart';
import '../../domain/repositories/movie_search_repository.dart';
import '../datasources/movie_search_local_data_source.dart';
import '../datasources/movie_search_remote_data_source.dart';

class MovieSearchRepositoryImpl implements MovieSearchRepository {
  final MovieSearchRemoteDataSource remoteDataSource;
  final MovieSearchLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  MovieSearchRepositoryImpl({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, MovieDetailed>> getMovieDetails(String id) {
    return null;
  }

  @override
  Future<Either<Failure, SearchResult>> searchMovie(String title, [int page = 1]) {
    return null;
  }
}
