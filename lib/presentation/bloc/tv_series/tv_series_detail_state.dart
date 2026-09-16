part of 'tv_series_detail_bloc.dart';

class TvSeriesDetailState extends Equatable {
  final RequestState tvSeriesState;
  final TvSeriesDetail? tvSeries;
  final RequestState recommendationState;
  final List<TvSeries> tvSeriesRecommendations;
  final bool isAddedToWatchlist;
  final String watchlistMessage;
  final String message;

  const TvSeriesDetailState({
    required this.tvSeriesState,
    required this.tvSeries,
    required this.recommendationState,
    required this.tvSeriesRecommendations,
    required this.isAddedToWatchlist,
    required this.watchlistMessage,
    required this.message,
  });

  factory TvSeriesDetailState.initial() => const TvSeriesDetailState(
        tvSeriesState: RequestState.Empty,
        tvSeries: null,
        recommendationState: RequestState.Empty,
        tvSeriesRecommendations: [],
        isAddedToWatchlist: false,
        watchlistMessage: '',
        message: '',
      );

  TvSeriesDetailState copyWith({
    RequestState? tvSeriesState,
    TvSeriesDetail? tvSeries,
    RequestState? recommendationState,
    List<TvSeries>? tvSeriesRecommendations,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
    String? message,
  }) {
    return TvSeriesDetailState(
      tvSeriesState: tvSeriesState ?? this.tvSeriesState,
      tvSeries: tvSeries ?? this.tvSeries,
      recommendationState: recommendationState ?? this.recommendationState,
      tvSeriesRecommendations:
          tvSeriesRecommendations ?? this.tvSeriesRecommendations,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        tvSeriesState,
        tvSeries,
        recommendationState,
        tvSeriesRecommendations,
        isAddedToWatchlist,
        watchlistMessage,
        message,
      ];
}
