import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/now_playing_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'now_playing_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTvSeries])
void main() {
  late MockGetNowPlayingTvSeries mockUsecase;
  late NowPlayingTvSeriesBloc bloc;

  setUp(() {
    mockUsecase = MockGetNowPlayingTvSeries();
    bloc = NowPlayingTvSeriesBloc(mockUsecase);
  });

  test('initial state should be empty', () {
    expect(bloc.state, NowPlayingTvSeriesEmpty());
  });

  blocTest<NowPlayingTvSeriesBloc, NowPlayingTvSeriesState>(
    'should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockUsecase.execute())
          .thenAnswer((_) async => Right(testTvSeriesList));
      return bloc;
    },
    act: (bloc) => bloc.add(OnNowPlayingTvSeriesRequested()),
    expect: () => [
      NowPlayingTvSeriesLoading(),
      NowPlayingTvSeriesHasData(testTvSeriesList),
    ],
    verify: (bloc) => verify(mockUsecase.execute()),
  );

  blocTest<NowPlayingTvSeriesBloc, NowPlayingTvSeriesState>(
    'should emit [Loading, Error] when getting data fails',
    build: () {
      when(mockUsecase.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(OnNowPlayingTvSeriesRequested()),
    expect: () => [
      NowPlayingTvSeriesLoading(),
      const NowPlayingTvSeriesError('Server Failure'),
    ],
  );
}
