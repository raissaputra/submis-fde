part of 'tv_series_detail_bloc.dart';

abstract class TvSeriesDetailEvent extends Equatable {
  const TvSeriesDetailEvent();

  @override
  List<Object> get props => [];
}

class OnTvSeriesDetailRequested extends TvSeriesDetailEvent {
  final int id;

  const OnTvSeriesDetailRequested(this.id);

  @override
  List<Object> get props => [id];
}

class OnLoadTvSeriesWatchlistStatus extends TvSeriesDetailEvent {
  final int id;

  const OnLoadTvSeriesWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class OnAddTvSeriesToWatchlist extends TvSeriesDetailEvent {
  final TvSeriesDetail tvSeries;

  const OnAddTvSeriesToWatchlist(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class OnRemoveTvSeriesFromWatchlist extends TvSeriesDetailEvent {
  final TvSeriesDetail tvSeries;

  const OnRemoveTvSeriesFromWatchlist(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}
