import 'package:core/data/models/genre_model.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final genreModel = GenreModel(id: 1, name: 'Action');
  final genreJson = {'id': 1, 'name': 'Action'};

  test('fromJson should return a valid GenreModel', () {
    final result = GenreModel.fromJson(genreJson);
    expect(result, genreModel);
  });

  test('toJson should return a JSON map with proper data', () {
    expect(genreModel.toJson(), genreJson);
  });

  test('toEntity should return a Genre entity', () {
    final result = genreModel.toEntity();
    expect(result, Genre(id: 1, name: 'Action'));
  });

  test('props expose value equality', () {
    expect(genreModel.props, [1, 'Action']);
    expect(Genre(id: 1, name: 'Action').props, [1, 'Action']);
  });
}
