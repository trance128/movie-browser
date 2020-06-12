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
  final SearchResultModel searchResult;
  final bool displayPagination;
  final bool displayFirstPageButton;
  final bool displayPrevPageButton;
  final bool displayNextPageButton;
  final bool displayFinalPageButton;

  SearchLoaded({
    @required this.searchResult,
    @required this.displayPagination,
    @required this.displayFirstPageButton,
    @required this.displayPrevPageButton,
    @required this.displayNextPageButton,
    @required this.displayFinalPageButton,
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

class DetailsLoading extends MovieSearchState{
  @override 
  List<Object> get props => [];
}

class DetailsLoaded extends MovieSearchState{
  final MovieDetailedModel movieDetailed;

  DetailsLoaded({@required this.movieDetailed});

  @override 
  List<Object> get props => [];
}

class DetailsError extends MovieSearchState {
  final String message;

  DetailsError({this.message});
  
  @override 
  List<Object> get props => [];
}