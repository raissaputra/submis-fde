import 'package:bloc/bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_series_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:equatable/equatable.dart';

part 'tv_series_detail_event.dart';
part 'tv_series_detail_state.dart';

class TvSeriesDetailBloc
    extends Bloc<TvSeriesDetailEvent, TvSeriesDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final GetWatchListTvSeriesStatus getWatchListStatus;
  final SaveWatchlistTvSeries saveWatchlist;
  final RemoveWatchlistTvSeries removeWatchlist;

  TvSeriesDetailBloc({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(TvSeriesDetailState.initial()) {
    on<OnTvSeriesDetailRequested>(_onDetailRequested);
    on<OnLoadTvSeriesWatchlistStatus>(_onLoadWatchlistStatus);
    on<OnAddTvSeriesToWatchlist>(_onAddWatchlist);
    on<OnRemoveTvSeriesFromWatchlist>(_onRemoveWatchlist);
  }

  Future<void> _onDetailRequested(
    OnTvSeriesDetailRequested event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    emit(state.copyWith(tvSeriesState: RequestState.Loading));
    final detailResult = await getTvSeriesDetail.execute(event.id);
    final recommendationResult =
        await getTvSeriesRecommendations.execute(event.id);

    detailResult.fold(
      (failure) {
        emit(state.copyWith(
          tvSeriesState: RequestState.Error,
          message: failure.message,
        ));
      },
      (tvSeries) {
        emit(state.copyWith(
          tvSeriesState: RequestState.Loaded,
          tvSeries: tvSeries,
          recommendationState: RequestState.Loading,
        ));
        recommendationResult.fold(
          (failure) {
            emit(state.copyWith(
              recommendationState: RequestState.Error,
              message: failure.message,
            ));
          },
          (tvSeriesData) {
            emit(state.copyWith(
              recommendationState: RequestState.Loaded,
              tvSeriesRecommendations: tvSeriesData,
            ));
          },
        );
      },
    );
  }

  Future<void> _onLoadWatchlistStatus(
    OnLoadTvSeriesWatchlistStatus event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final status = await getWatchListStatus.execute(event.id);
    emit(state.copyWith(isAddedToWatchlist: status));
  }

  Future<void> _onAddWatchlist(
    OnAddTvSeriesToWatchlist event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final result = await saveWatchlist.execute(event.tvSeries);
    final message = result.fold(
      (failure) => failure.message,
      (successMessage) => successMessage,
    );
    emit(state.copyWith(watchlistMessage: message));
    final status = await getWatchListStatus.execute(event.tvSeries.id);
    emit(state.copyWith(isAddedToWatchlist: status));
  }

  Future<void> _onRemoveWatchlist(
    OnRemoveTvSeriesFromWatchlist event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final result = await removeWatchlist.execute(event.tvSeries);
    final message = result.fold(
      (failure) => failure.message,
      (successMessage) => successMessage,
    );
    emit(state.copyWith(watchlistMessage: message));
    final status = await getWatchListStatus.execute(event.tvSeries.id);
    emit(state.copyWith(isAddedToWatchlist: status));
  }
}
