import 'dart:convert';

import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tTvSeriesModel = TvSeriesModel(
    backdropPath: "/path.jpg",
    firstAirDate: "2021-01-01",
    genreIds: [10765, 18],
    id: 1,
    name: "Name",
    originalName: "Original Name",
    overview: "Overview",
    popularity: 100.0,
    posterPath: "/path.jpg",
    voteAverage: 8.0,
    voteCount: 100,
  );
  final tTvSeriesResponseModel =
      TvSeriesResponse(tvSeriesList: <TvSeriesModel>[tTvSeriesModel]);

  test('should return a valid model from JSON', () async {
    // arrange
    final Map<String, dynamic> jsonMap =
        json.decode(readJson('dummy_data/tv_popular.json'));
    // act
    final result = TvSeriesResponse.fromJson(jsonMap);
    // assert
    expect(result, tTvSeriesResponseModel);
  });

  test('should return a JSON map containing proper data', () async {
    // act
    final result = tTvSeriesResponseModel.toJson();
    // assert
    final expectedJsonMap = {
      "results": [
        {
          "backdrop_path": "/path.jpg",
          "first_air_date": "2021-01-01",
          "genre_ids": [10765, 18],
          "id": 1,
          "name": "Name",
          "original_name": "Original Name",
          "overview": "Overview",
          "popularity": 100.0,
          "poster_path": "/path.jpg",
          "vote_average": 8.0,
          "vote_count": 100,
        }
      ],
    };
    expect(result, expectedJsonMap);
  });
}
