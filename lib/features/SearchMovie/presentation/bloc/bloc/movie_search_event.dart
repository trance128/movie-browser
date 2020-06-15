part of 'movie_search_bloc.dart';

abstract class MovieSearchEvent extends Equatable {
  const MovieSearchEvent();
}

class SearchMovieEvent extends MovieSearchEvent {
  final String title;
  final int page;

  SearchMovieEvent(this.title, [this.page = 1]);

  @override
  List<Object> get props => [title, page];
}

class SearchMovieNextPageEvent extends MovieSearchEvent {
  @override 
  List<Object> get props => [];  
}

class SearchMoviePrevPageEvent extends MovieSearchEvent {
  @override 
  List<Object> get props => [];
}

class SearchMovieFirstPageEvent extends MovieSearchEvent {
  @override 
  List<Object> get props => [];
}

class SearchMovieLastPageEvent extends MovieSearchEvent {
  @override 
  List<Object> get props => [];
}

class GetMovieDetailsEvent extends MovieSearchEvent {
  final String id;

  GetMovieDetailsEvent(this.id);

  @override
  List<Object> get props => [id];
}