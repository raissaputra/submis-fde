import 'package:bloc/bloc.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecases/get_watchlist_tv_series.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_tv_series_event.dart';
part 'watchlist_tv_series_state.dart';

class WatchlistTvSeriesBloc
    extends Bloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState> {
  final GetWatchlistTvSeries _getWatchlistTvSeries;

  WatchlistTvSeriesBloc(this._getWatchlistTvSeries)
      : super(WatchlistTvSeriesEmpty()) {
    on<OnWatchlistTvSeriesRequested>((event, emit) async {
      emit(WatchlistTvSeriesLoading());
      final result = await _getWatchlistTvSeries.execute();
      result.fold(
        (failure) => emit(WatchlistTvSeriesError(failure.message)),
        (data) => emit(WatchlistTvSeriesHasData(data)),
      );
    });
  }
}
