import 'package:dartz/dartz.dart';
import 'package:ditonton_tv/domain/usecases/get_airing_today_tvs.dart';
import 'package:ditonton_tv/domain/usecases/get_on_the_air_tvs.dart';
import 'package:ditonton_tv/domain/usecases/get_popular_tvs.dart';
import 'package:ditonton_tv/domain/usecases/get_season_detail.dart';
import 'package:ditonton_tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:ditonton_tv/domain/usecases/get_tv_detail.dart';
import 'package:ditonton_tv/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton_tv/domain/usecases/get_watchlist_tv_status.dart';
import 'package:ditonton_tv/domain/usecases/get_watchlist_tvs.dart';
import 'package:ditonton_tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton_tv/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton_tv/domain/usecases/search_tvs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects_tv.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockTVRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTVRepository();
  });

  test('should get airing today tvs from repository', () async {
    final usecase = GetAiringTodayTVs(mockTvRepository);
    when(mockTvRepository.getAiringTodayTvs())
        .thenAnswer((_) async => Right(testTvList));
    final result = await usecase.execute();
    expect(result, Right(testTvList));
  });

  test('should get on the air tvs from repository', () async {
    final usecase = GetOnTheAirTVs(mockTvRepository);
    when(mockTvRepository.getOnTheAirTvs())
        .thenAnswer((_) async => Right(testTvList));
    final result = await usecase.execute();
    expect(result, Right(testTvList));
  });

  test('should get popular tvs from repository', () async {
    final usecase = GetPopularTVs(mockTvRepository);
    when(mockTvRepository.getPopularTvs())
        .thenAnswer((_) async => Right(testTvList));
    final result = await usecase.execute();
    expect(result, Right(testTvList));
  });

  test('should get top rated tvs from repository', () async {
    final usecase = GetTopRatedTVs(mockTvRepository);
    when(mockTvRepository.getTopRatedTvs())
        .thenAnswer((_) async => Right(testTvList));
    final result = await usecase.execute();
    expect(result, Right(testTvList));
  });

  test('should get tv detail from repository', () async {
    final usecase = GetTVDetail(mockTvRepository);
    when(mockTvRepository.getTvDetail(1))
        .thenAnswer((_) async => const Right(testTvDetail));
    final result = await usecase.execute(1);
    expect(result, const Right(testTvDetail));
  });

  test('should get tv recommendations from repository', () async {
    final usecase = GetTVRecommendations(mockTvRepository);
    when(mockTvRepository.getTvRecommendations(1))
        .thenAnswer((_) async => Right(testTvList));
    final result = await usecase.execute(1);
    expect(result, Right(testTvList));
  });

  test('should get season detail from repository', () async {
    final usecase = GetSeasonDetail(mockTvRepository);
    when(mockTvRepository.getSeasonDetail(1, 1))
        .thenAnswer((_) async => const Right(testSeasonDetail));
    final result = await usecase.execute(1, 1);
    expect(result, const Right(testSeasonDetail));
  });

  test('should search tvs from repository', () async {
    final usecase = SearchTVs(mockTvRepository);
    when(mockTvRepository.searchTvs('test'))
        .thenAnswer((_) async => Right(testTvList));
    final result = await usecase.execute('test');
    expect(result, Right(testTvList));
  });

  test('should get watchlist tvs from repository', () async {
    final usecase = GetWatchlistTVs(mockTvRepository);
    when(mockTvRepository.getWatchlistTvs())
        .thenAnswer((_) async => Right(testTvList));
    final result = await usecase.execute();
    expect(result, Right(testTvList));
  });

  test('should get watchlist status from repository', () async {
    final usecase = GetWatchlistTVStatus(mockTvRepository);
    when(mockTvRepository.isAddedToWatchlist(1)).thenAnswer((_) async => true);
    final result = await usecase.execute(1);
    expect(result, true);
  });

  test('should save watchlist tv via repository', () async {
    final usecase = SaveWatchlistTV(mockTvRepository);
    when(mockTvRepository.saveWatchlist(testTvDetail))
        .thenAnswer((_) async => const Right('Added to Watchlist'));
    final result = await usecase.execute(testTvDetail);
    expect(result, const Right('Added to Watchlist'));
  });

  test('should remove watchlist tv via repository', () async {
    final usecase = RemoveWatchlistTV(mockTvRepository);
    when(mockTvRepository.removeWatchlist(testTvDetail))
        .thenAnswer((_) async => const Right('Removed from Watchlist'));
    final result = await usecase.execute(testTvDetail);
    expect(result, const Right('Removed from Watchlist'));
  });
}
