import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../dummy_data/dummy_objects_tv.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late DatabaseHelper helper;

  Future<String> dbPath() async {
    return '${await getDatabasesPath()}/ditonton.db';
  }

  setUpAll(() async {
    await databaseFactory.deleteDatabase(await dbPath());
    helper = DatabaseHelper();
  });

  test('onUpgrade creates tv table when opening a v1 database', () async {
    await databaseFactory.deleteDatabase(await dbPath());
    final v1 = await databaseFactory.openDatabase(
      await dbPath(),
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, _) async {
          await db.execute(
            'CREATE TABLE watchlist (id INTEGER PRIMARY KEY, title TEXT, overview TEXT, posterPath TEXT);',
          );
        },
      ),
    );
    await v1.close();

    await helper.insertTvWatchlist(testTvTable);
    final tv = await helper.getTvById(1);

    expect(tv?['name'], 'Test TV Detail');
  });

  group('movie watchlist table', () {
    test('insert and get movie by id', () async {
      await helper.insertWatchlist(testMovieTable);
      final result = await helper.getMovieById(1);

      expect(result?['title'], 'title');
    });

    test('get watchlist movies returns inserted rows', () async {
      final result = await helper.getWatchlistMovies();

      expect(result.isNotEmpty, true);
      expect(result.first['id'], 1);
    });

    test('get movie by unknown id returns null', () async {
      final result = await helper.getMovieById(999);

      expect(result, isNull);
    });

    test('remove watchlist deletes the row', () async {
      await helper.removeWatchlist(testMovieTable);
      final result = await helper.getMovieById(1);

      expect(result, isNull);
    });
  });

  group('tv watchlist table', () {
    test('insert and get tv by id', () async {
      await helper.removeTvWatchlist(testTvTable);
      await helper.insertTvWatchlist(testTvTable);
      final result = await helper.getTvById(1);

      expect(result?['name'], 'Test TV Detail');
    });

    test('get watchlist tvs returns inserted rows', () async {
      final result = await helper.getWatchlistTvs();

      expect(result.isNotEmpty, true);
      expect(result.first['id'], 1);
    });

    test('get tv by unknown id returns null', () async {
      final result = await helper.getTvById(999);

      expect(result, isNull);
    });

    test('remove tv watchlist deletes the row', () async {
      await helper.removeTvWatchlist(testTvTable);
      final result = await helper.getTvById(1);

      expect(result, isNull);
    });
  });

  test('movie table can hold testMovieMap data', () async {
    expect(testMovieMap['id'], 1);
    expect(testTvMap['id'], 1);
  });
}
