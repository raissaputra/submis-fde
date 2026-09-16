import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../dummy_data/dummy_objects.dart';

void main() {
  late DatabaseHelper databaseHelper;

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    final path = await getDatabasesPath();
    await deleteDatabase('$path/ditonton.db');
    databaseHelper = DatabaseHelper();
  });

  group('Movie watchlist', () {
    test('should insert, read and remove movie watchlist', () async {
      await databaseHelper.insertWatchlist(testMovieTable);

      final byId = await databaseHelper.getMovieById(testMovieTable.id);
      expect(byId, isNotNull);
      expect(byId!['id'], testMovieTable.id);

      final list = await databaseHelper.getWatchlistMovies();
      expect(list.length, 1);

      await databaseHelper.removeWatchlist(testMovieTable);
      final afterRemove =
          await databaseHelper.getMovieById(testMovieTable.id);
      expect(afterRemove, isNull);
    });
  });

  group('TV series watchlist', () {
    test('should insert, read and remove tv series watchlist', () async {
      await databaseHelper.insertWatchlistTvSeries(testTvSeriesTable);

      final byId =
          await databaseHelper.getTvSeriesById(testTvSeriesTable.id);
      expect(byId, isNotNull);
      expect(byId!['id'], testTvSeriesTable.id);

      final list = await databaseHelper.getWatchlistTvSeries();
      expect(list.length, 1);

      await databaseHelper.removeWatchlistTvSeries(testTvSeriesTable);
      final afterRemove =
          await databaseHelper.getTvSeriesById(testTvSeriesTable.id);
      expect(afterRemove, isNull);
    });

    test('getTvSeriesById returns null when not found', () async {
      final result = await databaseHelper.getTvSeriesById(999);
      expect(result, isNull);
    });
  });
}
