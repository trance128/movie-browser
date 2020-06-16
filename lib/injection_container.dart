import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'core/network/network_info.dart';
import 'features/SearchMovie/data/datasources/movie_search_local_data_source.dart';
import 'features/SearchMovie/data/datasources/movie_search_remote_data_source.dart';
import 'features/SearchMovie/data/models/movie_detailed_hive_model.dart';
import 'features/SearchMovie/data/models/search_result_hive_model.dart';
import 'features/SearchMovie/data/repositories/hive_movie_search_repository.dart';
import 'features/SearchMovie/data/repositories/movie_search_repository_impl.dart';
import 'features/SearchMovie/domain/repositories/movie_search_repository.dart';
import 'features/SearchMovie/domain/usecases/get_movie_details.dart';
import 'features/SearchMovie/domain/usecases/search_movie.dart';
import 'features/SearchMovie/presentation/bloc/bloc/movie_search_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features
  // bloc
  sl.registerFactory(
    () => MovieSearchBloc(
      search: sl(),
      getDetails: sl(),
    ),
  );

  // usecases
  sl.registerLazySingleton(() => SearchMovie(sl()));
  sl.registerLazySingleton(() => GetMovieDetails(sl()));

  // repository
  sl.registerLazySingleton<MovieSearchRepository>(
    () => MovieSearchRepositoryImpl(
      networkInfo: sl(),
      localDataSource: sl(),
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<MovieSearchLocalDataSource>(
      () => MovieSearchLocalDataSourceImpl(hiveMovieSearchRepo: sl()));
  sl.registerLazySingleton<MovieSearchRemoteDataSource>(
      () => MovieSearchRemoteDataSourceImpl(client: sl()));

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  sl.registerFactory(() => () => HiveMovieSearchRepo());
  sl.registerSingleton(() => http.Client());
  sl.registerSingleton(() => DataConnectionChecker());

  final path = Directory.current.path;
  Hive
    ..init(path)
    ..registerAdapter(MovieDetailedHiveAdapter())
    ..registerAdapter(SearchHiveAdapter());
}

