import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_browser/features/SearchMovie/domain/entities/movie_detailed_entity.dart';
import 'package:movie_browser/features/SearchMovie/domain/repositories/movie_search_repository.dart';
import 'package:movie_browser/features/SearchMovie/domain/usecases/get_movie_details.dart';

class MockMovieSearchRepository extends Mock implements MovieSearchRepository {}

void main() {
  GetMovieDetails usecase;
  MockMovieSearchRepository mockMovieSearchRepository;

  setUp(() {
    mockMovieSearchRepository = MockMovieSearchRepository();
    usecase = GetMovieDetails(mockMovieSearchRepository);
  });

  final String id = "1";
  final movieDetailed = MovieDetailed(id: id, title: 'Star Wars', year: 2002);

  test('should get MovieDetailed from MovieSearch repo', () async {
    // arrange
    when(mockMovieSearchRepository.getMovieDetails(any))
        .thenAnswer((_) async => Right(movieDetailed));

    // act
    final result = await usecase(Params(id: id));

    // assert
    expect(result, Right(movieDetailed));
    verify(mockMovieSearchRepository.getMovieDetails(id));
    verifyNoMoreInteractions(mockMovieSearchRepository);
  });
}
