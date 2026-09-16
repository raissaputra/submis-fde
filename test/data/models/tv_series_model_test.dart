import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvSeriesModel = TvSeriesModel(
    backdropPath: 'backdropPath',
    firstAirDate: 'firstAirDate',
    genreIds: [1, 2, 3],
    id: 1,
    name: 'name',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1.0,
    posterPath: 'posterPath',
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tTvSeries = TvSeries(
    backdropPath: 'backdropPath',
    firstAirDate: 'firstAirDate',
    genreIds: [1, 2, 3],
    id: 1,
    name: 'name',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1.0,
    posterPath: 'posterPath',
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tJson = {
    "backdrop_path": "backdropPath",
    "first_air_date": "firstAirDate",
    "genre_ids": [1, 2, 3],
    "id": 1,
    "name": "name",
    "original_name": "originalName",
    "overview": "overview",
    "popularity": 1.0,
    "poster_path": "posterPath",
    "vote_average": 1.0,
    "vote_count": 1,
  };

  test('should be a subclass of TvSeries entity', () async {
    final result = tTvSeriesModel.toEntity();
    expect(result, tTvSeries);
  });

  test('should return a valid model from JSON', () async {
    final result = TvSeriesModel.fromJson(tJson);
    expect(result, tTvSeriesModel);
  });

  test('should return a JSON map containing proper data', () async {
    final result = tTvSeriesModel.toJson();
    expect(result, tJson);
  });
}
