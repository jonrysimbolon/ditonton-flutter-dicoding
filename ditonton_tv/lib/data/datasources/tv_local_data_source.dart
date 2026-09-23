import 'package:ditonton_core/data/models/tv_table.dart';

abstract class TVLocalDataSource {
  Future<String> insertTvWatchlist(TVTable tv);
  Future<String> removeTvWatchlist(TVTable tv);
  Future<TVTable?> getTvById(int id);
  Future<List<TVTable>> getWatchlistTvs();
}
