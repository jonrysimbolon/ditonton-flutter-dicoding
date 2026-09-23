import 'package:ditonton_core/common/database_exception.dart';
import 'package:ditonton_core/data/datasources/db/database_helper.dart';
import 'package:ditonton_tv/data/datasources/tv_local_data_source.dart';
import 'package:ditonton_core/data/models/tv_table.dart';

class TVLocalDataSourceImpl implements TVLocalDataSource {
  final DatabaseHelper databaseHelper;

  TVLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertTvWatchlist(TVTable tv) async {
    try {
      await databaseHelper.insertTvWatchlist(tv);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeTvWatchlist(TVTable tv) async {
    try {
      await databaseHelper.removeTvWatchlist(tv);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TVTable?> getTvById(int id) async {
    final result = await databaseHelper.getTvById(id);
    if (result != null) {
      return TVTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TVTable>> getWatchlistTvs() async {
    final result = await databaseHelper.getWatchlistTvs();
    return result.map((data) => TVTable.fromMap(data)).toList();
  }
}
