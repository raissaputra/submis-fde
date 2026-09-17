import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:movie/domain/usecases/search_movies.dart';
import 'package:movie/presentation/bloc/movie/search_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'search_movies_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late MockSearchMovies mockSearchMovies;
  late SearchMoviesBloc bloc;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    bloc = SearchMoviesBloc(mockSearchMovies);
  });

  const tQuery = 'spiderman';

  test('initial state should be empty', () {
    expect(bloc.state, SearchMoviesEmpty());
  });

  blocTest<SearchMoviesBloc, SearchMoviesState>(
    'should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Right(testMovieList));
      return bloc;
    },
    act: (bloc) => bloc.add(const OnMovieQueryChanged(tQuery)),
    expect: () => [
      SearchMoviesLoading(),
      SearchMoviesHasData(testMovieList),
    ],
    verify: (bloc) => verify(mockSearchMovies.execute(tQuery)),
  );

  blocTest<SearchMoviesBloc, SearchMoviesState>(
    'should emit [Loading, Error] when getting data fails',
    build: () {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(const OnMovieQueryChanged(tQuery)),
    expect: () => [
      SearchMoviesLoading(),
      const SearchMoviesError('Server Failure'),
    ],
  );
}
