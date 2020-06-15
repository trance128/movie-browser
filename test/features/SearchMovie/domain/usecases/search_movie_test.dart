import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_browser/features/SearchMovie/domain/entities/search_result_entity.dart';
import 'package:movie_browser/features/SearchMovie/domain/repositories/movie_search_repository.dart';
import 'package:movie_browser/features/SearchMovie/domain/usecases/search_movie.dart';

class MockMovieSearchRepository extends Mock implements MovieSearchRepository {}

void main() {
  SearchMovie usecase;
  MockMovieSearchRepository mockMovieSearchRepository;

  setUp(() {
    mockMovieSearchRepository = MockMovieSearchRepository();
    usecase = SearchMovie(mockMovieSearchRepository);
  });

  final title = "Star Wars";
  final found = false;
  final page = 1;
  final totalResults = 0;
  final searchResult = SearchResult(
      title: title, found: found, page: page, totalResults: totalResults);

  test('should get searchResult for searched title from repository', () async {
    // arrange
    when(mockMovieSearchRepository.searchMovie(any))
        .thenAnswer((_) async => Right(searchResult));

    // act
    final result = await usecase(Params(title: title));

    // assert
    expect(result, Right(searchResult));
    // verify the method and none others has been called on the repo
    verify(mockMovieSearchRepository.searchMovie(title));
    verifyNoMoreInteractions(mockMovieSearchRepository);
  });
}
