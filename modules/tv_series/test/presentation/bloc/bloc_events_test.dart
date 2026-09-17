import 'package:flutter_test/flutter_test.dart';
import 'package:tv_series/presentation/bloc/tv_series/now_playing_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series/popular_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series/search_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series/top_rated_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series/tv_series_detail_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series/watchlist_tv_series_bloc.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  group('Tv series events equality', () {
    test('list & watchlist events support value equality', () {
      expect(OnNowPlayingTvSeriesRequested(), OnNowPlayingTvSeriesRequested());
      expect(OnPopularTvSeriesRequested(), OnPopularTvSeriesRequested());
      expect(OnTopRatedTvSeriesRequested(), OnTopRatedTvSeriesRequested());
      expect(
        OnWatchlistTvSeriesRequested(),
        OnWatchlistTvSeriesRequested(),
      );
      expect(
        const OnTvSeriesQueryChanged('a'),
        const OnTvSeriesQueryChanged('a'),
      );
      expect(const OnTvSeriesQueryChanged('a').props, ['a']);
    });

    test('detail events support value equality', () {
      expect(
        const OnTvSeriesDetailRequested(1),
        const OnTvSeriesDetailRequested(1),
      );
      expect(
        const OnLoadTvSeriesWatchlistStatus(1),
        const OnLoadTvSeriesWatchlistStatus(1),
      );
      expect(
        OnAddTvSeriesToWatchlist(testTvSeriesDetail),
        OnAddTvSeriesToWatchlist(testTvSeriesDetail),
      );
      expect(
        OnRemoveTvSeriesFromWatchlist(testTvSeriesDetail),
        OnRemoveTvSeriesFromWatchlist(testTvSeriesDetail),
      );
    });

    test('detail events expose props', () {
      expect(const OnTvSeriesDetailRequested(1).props, [1]);
      expect(const OnLoadTvSeriesWatchlistStatus(1).props, [1]);
      expect(
        OnAddTvSeriesToWatchlist(testTvSeriesDetail).props,
        [testTvSeriesDetail],
      );
      expect(
        OnRemoveTvSeriesFromWatchlist(testTvSeriesDetail).props,
        [testTvSeriesDetail],
      );
    });
  });
}
