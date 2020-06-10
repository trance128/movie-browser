import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:movie_browser/core/error/exception.dart';

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
  Future<Either<Failure, SearchResult>> searchMovie(String title,
      [int page = 1]) async {
    // get locally stored search.  If it fails, get remote data
    try {
      final SearchResult cachedSearchResult =
          await localDataSource.getCachedSearch(title, page);

      return Right(cachedSearchResult);
    } on CacheException {
      // get remote data and cache it if we have a network, otherwise
      // throw network error
      if (await networkInfo.isConnected) {
        try {
          final remoteSearch = await remoteDataSource.searchMovie(title, page);
          localDataSource.cacheSearch(remoteSearch);

          return Right(remoteSearch);
        } on ServerException {
          return Left(ServerFailure());
        }
      } else {
        return Left(NetworkFailure());
      }
    }
  }

  @override
  Future<Either<Failure, MovieDetailed>> getMovieDetails(String id) async {
    // if present, get cached movie.  Otherwise, get remote
    try {
      final MovieDetailed cachedMovie =
          await localDataSource.getCachedMovieDetails(id);

      return Right(cachedMovie);
    } on CacheException {
      // if we have a network connection, get remote data and cache it locally
      // otherwise, return [NetworkFailure]
      if (await networkInfo.isConnected) {
        try {
          final remoteMovie = await remoteDataSource.getMovieDetails(id);
          localDataSource.cacheMovieDetails(remoteMovie);

          return Right(remoteMovie);
        } on ServerException {
          return Left(ServerFailure());
        }
      } else {
        return Left(NetworkFailure());
      }
    }
  }
}
