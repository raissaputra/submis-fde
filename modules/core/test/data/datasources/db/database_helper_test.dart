import 'package:core/data/datasources/db/database_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late DatabaseHelper databaseHelper;

  final testMovieMap = {
    'id': 1,
    'title': 'title',
    'posterPath': 'posterPath',
    'overview': 'overview',
  };

  final testTvSeriesMap = {
    'id': 1,
    'name': 'name',
    'posterPath': 'posterPath',
    'overview': 'overview',
  };

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final path = await getDatabasesPath();
    await deleteDatabase('$path/ditonton.db');
    databaseHelper = DatabaseHelper();
  });

  group('Movie watchlist', () {
    test('should insert, read and remove movie watchlist', () async {
      await databaseHelper.insertWatchlist(testMovieMap);

      final byId = await databaseHelper.getMovieById(testMovieMap['id'] as int);
      expect(byId, isNotNull);
      expect(byId!['id'], testMovieMap['id']);

      final list = await databaseHelper.getWatchlistMovies();
      expect(list.length, 1);

      await databaseHelper.removeWatchlist(testMovieMap);
      final afterRemove =
          await databaseHelper.getMovieById(testMovieMap['id'] as int);
      expect(afterRemove, isNull);
    });
  });

  group('TV series watchlist', () {
    test('should insert, read and remove tv series watchlist', () async {
      await databaseHelper.insertWatchlistTvSeries(testTvSeriesMap);

      final byId =
          await databaseHelper.getTvSeriesById(testTvSeriesMap['id'] as int);
      expect(byId, isNotNull);
      expect(byId!['id'], testTvSeriesMap['id']);

      final list = await databaseHelper.getWatchlistTvSeries();
      expect(list.length, 1);

      await databaseHelper.removeWatchlistTvSeries(testTvSeriesMap);
      final afterRemove =
          await databaseHelper.getTvSeriesById(testTvSeriesMap['id'] as int);
      expect(afterRemove, isNull);
    });

    test('getTvSeriesById returns null when not found', () async {
      final result = await databaseHelper.getTvSeriesById(999);
      expect(result, isNull);
    });
  });
}
