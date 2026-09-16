import 'package:ditonton/presentation/bloc/movie/movie_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/now_playing_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/search_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/now_playing_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/popular_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/search_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/top_rated_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/watchlist_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  group('Movie events equality', () {
    test('list & watchlist events support value equality', () {
      expect(OnNowPlayingMoviesRequested(), OnNowPlayingMoviesRequested());
      expect(OnPopularMoviesRequested(), OnPopularMoviesRequested());
      expect(OnTopRatedMoviesRequested(), OnTopRatedMoviesRequested());
      expect(OnWatchlistMoviesRequested(), OnWatchlistMoviesRequested());
      expect(
        const OnMovieQueryChanged('a'),
        const OnMovieQueryChanged('a'),
      );
      expect(const OnMovieQueryChanged('a').props, ['a']);
    });

    test('detail events support value equality', () {
      expect(
        const OnMovieDetailRequested(1),
        const OnMovieDetailRequested(1),
      );
      expect(
        const OnLoadMovieWatchlistStatus(1),
        const OnLoadMovieWatchlistStatus(1),
      );
      expect(
        OnAddMovieToWatchlist(testMovieDetail),
        OnAddMovieToWatchlist(testMovieDetail),
      );
      expect(
        OnRemoveMovieFromWatchlist(testMovieDetail),
        OnRemoveMovieFromWatchlist(testMovieDetail),
      );
    });

    test('detail events expose props', () {
      expect(const OnMovieDetailRequested(1).props, [1]);
      expect(const OnLoadMovieWatchlistStatus(1).props, [1]);
      expect(
        OnAddMovieToWatchlist(testMovieDetail).props,
        [testMovieDetail],
      );
      expect(
        OnRemoveMovieFromWatchlist(testMovieDetail).props,
        [testMovieDetail],
      );
    });
  });

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
