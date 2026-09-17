/// Central route names shared across feature modules so that a module can
/// navigate to another module's page (via named routes) without importing it,
/// avoiding circular dependencies between `movie` and `tv_series`.
class AppRoutes {
  static const home = '/home';
  static const popularMovies = '/popular-movie';
  static const topRatedMovies = '/top-rated-movie';
  static const movieDetail = '/detail';
  static const searchMovies = '/search';
  static const watchlistMovies = '/watchlist-movie';

  static const homeTvSeries = '/home-tv-series';
  static const popularTvSeries = '/popular-tv-series';
  static const topRatedTvSeries = '/top-rated-tv-series';
  static const tvSeriesDetail = '/detail-tv-series';
  static const searchTvSeries = '/search-tv-series';
  static const watchlistTvSeries = '/watchlist-tv-series';

  static const about = '/about';
}
