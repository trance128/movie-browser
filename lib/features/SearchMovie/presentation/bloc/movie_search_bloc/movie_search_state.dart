part of 'movie_search_bloc.dart';

abstract class MovieSearchState extends Equatable {
  const MovieSearchState();
}

class MovieSearchInitial extends MovieSearchState {
  @override
  List<Object> get props => [];
}

class SearchLoading extends MovieSearchState {
  @override
  List<Object> get props => [];
}

class SearchLoaded extends MovieSearchState {
  final SearchHive searchResult;

  SearchLoaded({
    @required this.searchResult,
  });

  @override
  List<Object> get props => [searchResult];
}

class SearchError extends MovieSearchState {
  final String message;

  SearchError({this.message});

  @override
  List<Object> get props => [message];
}

class DetailsLoading extends MovieSearchState {
  @override
  List<Object> get props => [];
}

class DetailsLoaded extends MovieSearchState {
  final MovieDetailedHive movieDetailed;

  DetailsLoaded({@required this.movieDetailed});

  @override
  List<Object> get props => [movieDetailed];
}

class DetailsError extends MovieSearchState {
  final String message;

  DetailsError({this.message});

  @override
  List<Object> get props => [];
}
