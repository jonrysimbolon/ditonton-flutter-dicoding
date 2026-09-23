import 'package:ditonton_core/data/models/tv_table.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects_tv.dart';

void main() {
  test('should create TVTable from entity', () async {
    final result = TVTable.fromEntity(testTvDetail);
    expect(result, testTvTable);
  });

  test('should create TVTable from map', () async {
    final result = TVTable.fromMap(testTvMap);
    expect(result, testTvTable);
  });

  test('should return json map correctly', () async {
    final result = testTvTable.toJson();
    expect(result, testTvMap);
  });

  test('should map to TV watchlist entity', () async {
    final result = testTvTable.toEntity();
    expect(result, testWatchlistTv);
    expect(testTvTable.props.isNotEmpty, true);
  });
}
