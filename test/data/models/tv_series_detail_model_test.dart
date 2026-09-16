import 'dart:convert';

import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  test('should return a valid model from JSON', () async {
    // arrange
    final Map<String, dynamic> jsonMap =
        json.decode(readJson('dummy_data/tv_series_detail.json'));
    // act
    final result = TvSeriesDetailResponse.fromJson(jsonMap);
    // assert
    expect(result.id, 1);
    expect(result.name, 'Name');
    expect(result.numberOfSeasons, 2);
    expect(result.numberOfEpisodes, 16);
    expect(result.seasons.length, 1);
    expect(result.genres.length, 1);
    expect(result.episodeRunTime, [45]);
  });

  test('should convert response to entity correctly', () async {
    // arrange
    final Map<String, dynamic> jsonMap =
        json.decode(readJson('dummy_data/tv_series_detail.json'));
    final response = TvSeriesDetailResponse.fromJson(jsonMap);
    // act
    final result = response.toEntity();
    // assert
    expect(result.id, 1);
    expect(result.name, 'Name');
    expect(result.seasons.first.name, 'Season 1');
    expect(result.genres.first.name, 'Drama');
  });

  test('should return a JSON map containing proper data', () async {
    // arrange
    final Map<String, dynamic> jsonMap =
        json.decode(readJson('dummy_data/tv_series_detail.json'));
    final response = TvSeriesDetailResponse.fromJson(jsonMap);
    // act
    final result = response.toJson();
    // assert
    expect(result['id'], 1);
    expect(result['name'], 'Name');
    expect(result['number_of_seasons'], 2);
  });

  test('two responses parsed from same JSON should be equal', () async {
    final Map<String, dynamic> jsonMap =
        json.decode(readJson('dummy_data/tv_series_detail.json'));
    final a = TvSeriesDetailResponse.fromJson(jsonMap);
    final b = TvSeriesDetailResponse.fromJson(jsonMap);
    expect(a, equals(b));
    expect(a.props.length, greaterThan(0));
  });
}
