import 'package:ditonton/data/models/tv_series_table.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  test('should create table from TvSeriesDetail entity', () {
    final result = TvSeriesTable.fromEntity(testTvSeriesDetail);
    expect(result, testTvSeriesTable);
  });

  test('should create table from map', () {
    final result = TvSeriesTable.fromMap(testTvSeriesMap);
    expect(result, testTvSeriesTable);
  });

  test('should convert table to JSON map', () {
    final result = testTvSeriesTable.toJson();
    expect(result, testTvSeriesMap);
  });

  test('should convert table to TvSeries entity', () {
    final result = testTvSeriesTable.toEntity();
    expect(result, isA<TvSeries>());
    expect(result.id, testTvSeriesTable.id);
    expect(result.name, testTvSeriesTable.name);
  });
}
