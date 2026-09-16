import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/watchlist_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTvSeries])
void main() {
  late MockGetWatchlistTvSeries mockUsecase;
  late WatchlistTvSeriesBloc bloc;

  setUp(() {
    mockUsecase = MockGetWatchlistTvSeries();
    bloc = WatchlistTvSeriesBloc(mockUsecase);
  });

  test('initial state should be empty', () {
    expect(bloc.state, WatchlistTvSeriesEmpty());
  });

  blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
    'should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockUsecase.execute())
          .thenAnswer((_) async => Right([testWatchlistTvSeries]));
      return bloc;
    },
    act: (bloc) => bloc.add(OnWatchlistTvSeriesRequested()),
    expect: () => [
      WatchlistTvSeriesLoading(),
      WatchlistTvSeriesHasData([testWatchlistTvSeries]),
    ],
    verify: (bloc) => verify(mockUsecase.execute()),
  );

  blocTest<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
    'should emit [Loading, Error] when getting data fails',
    build: () {
      when(mockUsecase.execute()).thenAnswer(
          (_) async => Left(DatabaseFailure("Can't get data")));
      return bloc;
    },
    act: (bloc) => bloc.add(OnWatchlistTvSeriesRequested()),
    expect: () => [
      WatchlistTvSeriesLoading(),
      const WatchlistTvSeriesError("Can't get data"),
    ],
  );
}
