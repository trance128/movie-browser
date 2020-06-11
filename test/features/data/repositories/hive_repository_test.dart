import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_browser/features/SearchMovie/data/repositories/hive_movie_search_repository.dart';

class MockHiveMovieSearchRepoAbstract extends Mock
    implements HiveMovieSearchRepoAbstract {}

class MockHiveMovieSearchRepo extends Mock implements HiveMovieSearchRepo{}

class MockBox extends Mock implements Box{}

void main() {
  MockHiveMovieSearchRepo mockHiveMovieSearchRepo;
  MockBox box;

  setUp(() {
    mockHiveMovieSearchRepo = MockHiveMovieSearchRepo();
  });

  test('should be a subclass of HiveMovieSearchRepoAbstract', () {
    expect(mockHiveMovieSearchRepo, isA<HiveMovieSearchRepoAbstract>());
  });

  // I can't think how to test the box opening logic?  All my ideas seem to loop, only testing 
  // the test
  
  // group('box is not yet open', () {
  //   setUp(() {
  //     box = null;
  //   });

  //   test('', () {
      
  //   });
  // });
}
