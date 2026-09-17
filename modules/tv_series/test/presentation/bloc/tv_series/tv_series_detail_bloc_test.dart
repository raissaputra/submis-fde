import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/common/failure.dart';
import 'package:core/common/state_enum.dart';
import 'package:tv_series/domain/usecases/get_tv_series_detail.dart';
import 'package:tv_series/domain/usecases/get_tv_series_recommendations.dart';
import 'package:tv_series/domain/usecases/get_watchlist_tv_series_status.dart';
import 'package:tv_series/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:tv_series/domain/usecases/save_watchlist_tv_series.dart';
import 'package:tv_series/presentation/bloc/tv_series/tv_series_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tv_series_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvSeriesDetail,
  GetTvSeriesRecommendations,
  GetWatchListTvSeriesStatus,
  SaveWatchlistTvSeries,
  RemoveWatchlistTvSeries,
])
void main() {
  late TvSeriesDetailBloc bloc;
  late MockGetTvSeriesDetail mockGetDetail;
  late MockGetTvSeriesRecommendations mockGetRecommendations;
  late MockGetWatchListTvSeriesStatus mockGetWatchListStatus;
  late MockSaveWatchlistTvSeries mockSaveWatchlist;
  late MockRemoveWatchlistTvSeries mockRemoveWatchlist;

  setUp(() {
    mockGetDetail = MockGetTvSeriesDetail();
    mockGetRecommendations = MockGetTvSeriesRecommendations();
    mockGetWatchListStatus = MockGetWatchListTvSeriesStatus();
    mockSaveWatchlist = MockSaveWatchlistTvSeries();
    mockRemoveWatchlist = MockRemoveWatchlistTvSeries();
    bloc = TvSeriesDetailBloc(
      getTvSeriesDetail: mockGetDetail,
      getTvSeriesRecommendations: mockGetRecommendations,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  const tId = 1;

  test('initial state should be the initial detail state', () {
    expect(bloc.state, TvSeriesDetailState.initial());
  });

  group('Get Tv Series Detail', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit detail Loaded and recommendation Loaded when both succeed',
      build: () {
        when(mockGetDetail.execute(tId))
            .thenAnswer((_) async => Right(testTvSeriesDetail));
        when(mockGetRecommendations.execute(tId))
            .thenAnswer((_) async => Right(testTvSeriesList));
        return bloc;
      },
      act: (bloc) => bloc.add(const OnTvSeriesDetailRequested(tId)),
      expect: () => [
        TvSeriesDetailState.initial()
            .copyWith(tvSeriesState: RequestState.Loading),
        TvSeriesDetailState.initial().copyWith(
          tvSeriesState: RequestState.Loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.Loading,
        ),
        TvSeriesDetailState.initial().copyWith(
          tvSeriesState: RequestState.Loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.Loaded,
          tvSeriesRecommendations: testTvSeriesList,
        ),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit detail Error when getting detail fails',
      build: () {
        when(mockGetDetail.execute(tId))
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        when(mockGetRecommendations.execute(tId))
            .thenAnswer((_) async => Right(testTvSeriesList));
        return bloc;
      },
      act: (bloc) => bloc.add(const OnTvSeriesDetailRequested(tId)),
      expect: () => [
        TvSeriesDetailState.initial()
            .copyWith(tvSeriesState: RequestState.Loading),
        TvSeriesDetailState.initial().copyWith(
          tvSeriesState: RequestState.Error,
          message: 'Failed',
        ),
      ],
    );
  });

  group('Watchlist', () {
    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit isAddedToWatchlist true when status is loaded',
      build: () {
        when(mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(const OnLoadTvSeriesWatchlistStatus(tId)),
      expect: () => [
        TvSeriesDetailState.initial().copyWith(isAddedToWatchlist: true),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit watchlist message and status when added successfully',
      build: () {
        when(mockSaveWatchlist.execute(testTvSeriesDetail)).thenAnswer(
            (_) async => Right(TvSeriesDetailBloc.watchlistAddSuccessMessage));
        when(mockGetWatchListStatus.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(OnAddTvSeriesToWatchlist(testTvSeriesDetail)),
      expect: () => [
        TvSeriesDetailState.initial().copyWith(
          watchlistMessage: TvSeriesDetailBloc.watchlistAddSuccessMessage,
        ),
        TvSeriesDetailState.initial().copyWith(
          watchlistMessage: TvSeriesDetailBloc.watchlistAddSuccessMessage,
          isAddedToWatchlist: true,
        ),
      ],
    );

    blocTest<TvSeriesDetailBloc, TvSeriesDetailState>(
      'should emit watchlist message and status when removed successfully',
      build: () {
        when(mockRemoveWatchlist.execute(testTvSeriesDetail)).thenAnswer(
            (_) async =>
                Right(TvSeriesDetailBloc.watchlistRemoveSuccessMessage));
        when(mockGetWatchListStatus.execute(testTvSeriesDetail.id))
            .thenAnswer((_) async => false);
        return bloc;
      },
      seed: () =>
          TvSeriesDetailState.initial().copyWith(isAddedToWatchlist: true),
      act: (bloc) =>
          bloc.add(OnRemoveTvSeriesFromWatchlist(testTvSeriesDetail)),
      expect: () => [
        TvSeriesDetailState.initial().copyWith(
          isAddedToWatchlist: true,
          watchlistMessage: TvSeriesDetailBloc.watchlistRemoveSuccessMessage,
        ),
        TvSeriesDetailState.initial().copyWith(
          isAddedToWatchlist: false,
          watchlistMessage: TvSeriesDetailBloc.watchlistRemoveSuccessMessage,
        ),
      ],
    );
  });
}
