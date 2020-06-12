part of 'movie_search_bloc.dart';

abstract class MovieSearchEvent extends Equatable {
  const MovieSearchEvent();
}

class SearchMovie extends MovieSearchEvent {
  final String title;
  final int page;

  SearchMovie(this.title, [this.page = 1]);

  @override
  List<Object> get props => [title, page];
}

class SearchMovieNextPage extends MovieSearchEvent {
  @override 
  List<Object> get props => [];  
}

class SearchMoviePrevPage extends MovieSearchEvent {
  @override 
  List<Object> get props => [];
}

class SearchMovieFirstPage extends MovieSearchEvent {
  @override 
  List<Object> get props => [];
}

class SearchMovieLastPage extends MovieSearchEvent {
  @override 
  List<Object> get props => [];
}

class GetMovieDetails extends MovieSearchEvent {
  final String id;

  GetMovieDetails(this.id);

  @override
  List<Object> get props => [id];
}