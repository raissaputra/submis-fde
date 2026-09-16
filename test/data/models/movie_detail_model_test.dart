import 'dart:convert';

import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  test('should return a valid model from JSON', () async {
    final Map<String, dynamic> jsonMap =
        json.decode(readJson('dummy_data/movie_detail.json'));
    final result = MovieDetailResponse.fromJson(jsonMap);
    expect(result, isA<MovieDetailResponse>());
    expect(result.title, isNotNull);
    expect(result.genres, isNotEmpty);
  });

  test('should convert response to entity correctly', () async {
    final Map<String, dynamic> jsonMap =
        json.decode(readJson('dummy_data/movie_detail.json'));
    final response = MovieDetailResponse.fromJson(jsonMap);
    final result = response.toEntity();
    expect(result.id, response.id);
    expect(result.title, response.title);
    expect(result.genres.length, response.genres.length);
  });

  test('should return a JSON map containing proper data', () async {
    final Map<String, dynamic> jsonMap =
        json.decode(readJson('dummy_data/movie_detail.json'));
    final response = MovieDetailResponse.fromJson(jsonMap);
    final result = response.toJson();
    expect(result['id'], response.id);
    expect(result['title'], response.title);
  });

  test('two responses parsed from same JSON should be equal', () async {
    final Map<String, dynamic> jsonMap =
        json.decode(readJson('dummy_data/movie_detail.json'));
    final a = MovieDetailResponse.fromJson(jsonMap);
    final b = MovieDetailResponse.fromJson(jsonMap);
    expect(a, equals(b));
    expect(a.props.length, greaterThan(0));
  });
}
