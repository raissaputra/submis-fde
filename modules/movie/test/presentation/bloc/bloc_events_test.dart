import 'package:flutter_test/flutter_test.dart';
import 'package:movie/presentation/bloc/movie/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie/now_playing_movies_bloc.dart';
import 'package:movie/presentation/bloc/movie/popular_movies_bloc.dart';
import 'package:movie/presentation/bloc/movie/search_movies_bloc.dart';
import 'package:movie/presentation/bloc/movie/top_rated_movies_bloc.dart';
import 'package:movie/presentation/bloc/movie/watchlist_movies_bloc.dart';

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
}
