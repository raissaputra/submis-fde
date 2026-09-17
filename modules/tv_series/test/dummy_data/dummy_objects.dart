import 'package:core/domain/entities/genre.dart';
import 'package:tv_series/data/models/tv_series_table.dart';
import 'package:tv_series/domain/entities/season.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/entities/tv_series_detail.dart';

final testTvSeries = TvSeries(
  backdropPath: '/path.jpg',
  firstAirDate: '2021-01-01',
  genreIds: [10765, 18],
  id: 1,
  name: 'Name',
  originalName: 'Original Name',
  overview: 'Overview',
  popularity: 100.0,
  posterPath: '/path.jpg',
  voteAverage: 8.0,
  voteCount: 100,
);

final testTvSeriesList = [testTvSeries];

final testTvSeriesDetail = TvSeriesDetail(
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  name: 'name',
  originalName: 'originalName',
  overview: 'overview',
  posterPath: 'posterPath',
  firstAirDate: 'firstAirDate',
  numberOfSeasons: 2,
  numberOfEpisodes: 16,
  episodeRunTime: [45],
  seasons: [
    Season(
      airDate: '2021-01-01',
      episodeCount: 8,
      id: 1,
      name: 'Season 1',
      overview: 'overview',
      posterPath: 'posterPath',
      seasonNumber: 1,
    ),
  ],
  voteAverage: 8.0,
  voteCount: 100,
);

final testWatchlistTvSeries = TvSeries.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvSeriesTable = TvSeriesTable(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTvSeriesMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'name': 'name',
};
