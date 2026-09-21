import 'package:ditonton/common/database_exception.dart';
import 'package:ditonton/data/datasources/tv_local_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects_tv.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TVLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = TVLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save tv watchlist', () {
    test(
      'should return success message when insert to database is success',
      () async {
        when(mockDatabaseHelper.insertTvWatchlist(testTvTable))
            .thenAnswer((_) async => 1);
        final result = await dataSource.insertTvWatchlist(testTvTable);
        expect(result, 'Added to Watchlist');
      },
    );

    test(
      'should throw DatabaseException when insert to database is failed',
      () async {
        when(mockDatabaseHelper.insertTvWatchlist(testTvTable))
            .thenThrow(Exception('Failed'));
        final call = dataSource.insertTvWatchlist(testTvTable);
        expect(() => call, throwsA(isA<DatabaseException>()));
      },
    );
  });

  group('remove tv watchlist', () {
    test(
      'should return success message when remove from database is success',
      () async {
        when(mockDatabaseHelper.removeTvWatchlist(testTvTable))
            .thenAnswer((_) async => 1);
        final result = await dataSource.removeTvWatchlist(testTvTable);
        expect(result, 'Removed from Watchlist');
      },
    );

    test(
      'should throw DatabaseException when remove from database is failed',
      () async {
        when(mockDatabaseHelper.removeTvWatchlist(testTvTable))
            .thenThrow(Exception('Failed'));
        final call = dataSource.removeTvWatchlist(testTvTable);
        expect(() => call, throwsA(isA<DatabaseException>()));
      },
    );
  });

  group('get tv by id', () {
    test('should return TVTable when data is found', () async {
      when(mockDatabaseHelper.getTvById(1)).thenAnswer((_) async => testTvMap);
      final result = await dataSource.getTvById(1);
      expect(result, testTvTable);
    });

    test('should return null when data is not found', () async {
      when(mockDatabaseHelper.getTvById(1)).thenAnswer((_) async => null);
      final result = await dataSource.getTvById(1);
      expect(result, null);
    });
  });

  group('get watchlist tvs', () {
    test('should return list of TVTable from database', () async {
      when(mockDatabaseHelper.getWatchlistTvs())
          .thenAnswer((_) async => [testTvMap]);
      final result = await dataSource.getWatchlistTvs();
      expect(result, [testTvTable]);
    });
  });
}
