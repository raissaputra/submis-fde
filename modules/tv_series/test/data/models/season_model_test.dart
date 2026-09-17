import 'package:tv_series/data/models/season_model.dart';
import 'package:tv_series/domain/entities/season.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tSeasonModel = SeasonModel(
    airDate: '2021-01-01',
    episodeCount: 8,
    id: 1,
    name: 'Season 1',
    overview: 'overview',
    posterPath: 'posterPath',
    seasonNumber: 1,
  );

  final tSeason = Season(
    airDate: '2021-01-01',
    episodeCount: 8,
    id: 1,
    name: 'Season 1',
    overview: 'overview',
    posterPath: 'posterPath',
    seasonNumber: 1,
  );

  final tJson = {
    "air_date": "2021-01-01",
    "episode_count": 8,
    "id": 1,
    "name": "Season 1",
    "overview": "overview",
    "poster_path": "posterPath",
    "season_number": 1,
  };

  test('should be a subclass of Season entity', () async {
    final result = tSeasonModel.toEntity();
    expect(result, tSeason);
  });

  test('should return a valid model from JSON', () async {
    final result = SeasonModel.fromJson(tJson);
    expect(result, tSeasonModel);
  });

  test('should return a JSON map containing proper data', () async {
    final result = tSeasonModel.toJson();
    expect(result, tJson);
  });
}
