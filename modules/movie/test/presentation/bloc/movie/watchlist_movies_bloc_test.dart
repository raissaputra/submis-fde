import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:movie/domain/usecases/get_watchlist_movies.dart';
import 'package:movie/presentation/bloc/movie/watchlist_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_movies_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late WatchlistMoviesBloc bloc;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    bloc = WatchlistMoviesBloc(mockGetWatchlistMovies);
  });

  test('initial state should be empty', () {
    expect(bloc.state, WatchlistMoviesEmpty());
  });

  blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
    'should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right([testWatchlistMovie]));
      return bloc;
    },
    act: (bloc) => bloc.add(OnWatchlistMoviesRequested()),
    expect: () => [
      WatchlistMoviesLoading(),
      WatchlistMoviesHasData([testWatchlistMovie]),
    ],
    verify: (bloc) => verify(mockGetWatchlistMovies.execute()),
  );

  blocTest<WatchlistMoviesBloc, WatchlistMoviesState>(
    'should emit [Loading, Error] when getting data fails',
    build: () {
      when(mockGetWatchlistMovies.execute()).thenAnswer(
          (_) async => Left(DatabaseFailure("Can't get data")));
      return bloc;
    },
    act: (bloc) => bloc.add(OnWatchlistMoviesRequested()),
    expect: () => [
      WatchlistMoviesLoading(),
      const WatchlistMoviesError("Can't get data"),
    ],
  );
}
