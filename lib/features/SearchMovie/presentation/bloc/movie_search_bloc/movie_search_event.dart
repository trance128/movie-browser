part of 'movie_search_bloc.dart';

abstract class MovieSearchEvent extends Equatable {
  const MovieSearchEvent();
}

class TitleChangedEvent extends MovieSearchEvent {
  final String title;

  const TitleChangedEvent(this.title);

  @override 
  List<Object> get props => [title];
}

class SearchMovieEvent extends MovieSearchEvent {
  final int page;

  SearchMovieEvent([this.page = 1]);

  @override
  List<Object> get props => [page];
}

class SearchMovieMoreResultsEvent extends MovieSearchEvent {
  SearchMovieMoreResultsEvent();

  @override 
  List<Object> get props => [];
}

class GetMovieDetailsEvent extends MovieSearchEvent {
  final String id;

  GetMovieDetailsEvent(this.id);

  @override
  List<Object> get props => [id];
}
