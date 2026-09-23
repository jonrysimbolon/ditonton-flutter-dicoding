import 'package:ditonton_tv/data/models/season_detail_model.dart';
import 'package:ditonton_tv/data/models/tv_detail_model.dart';
import 'package:ditonton_tv/data/models/tv_model.dart';

abstract class TVRemoteDataSource {
  Future<List<TVModel>> getAiringTodayTvs();
  Future<List<TVModel>> getOnTheAirTvs();
  Future<List<TVModel>> getPopularTvs();
  Future<List<TVModel>> getTopRatedTvs();
  Future<TVDetailModel> getTvDetail(int id);
  Future<List<TVModel>> getTvRecommendations(int id);
  Future<SeasonDetailModel> getSeasonDetail(int id, int seasonNumber);
  Future<List<TVModel>> searchTvs(String query);
}
