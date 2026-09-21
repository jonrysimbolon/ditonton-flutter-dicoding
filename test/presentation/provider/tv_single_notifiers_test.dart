import 'package:dartz/dartz.dart';
import 'package:ditonton/common/server_failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_airing_today_tvs.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tvs.dart';
import 'package:ditonton/domain/usecases/get_popular_tvs.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tvs.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tvs.dart';
import 'package:ditonton/domain/usecases/search_tvs.dart';
import 'package:ditonton/presentation/provider/airing_today_tvs_notifier.dart';
import 'package:ditonton/presentation/provider/on_the_air_tvs_notifier.dart';
import 'package:ditonton/presentation/provider/popular_tvs_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_tvs_notifier.dart';
import 'package:ditonton/presentation/provider/tv_search_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_single_notifiers_test.mocks.dart';

@GenerateMocks([
  GetAiringTodayTVs,
  GetOnTheAirTVs,
  GetPopularTVs,
  GetTopRatedTVs,
  SearchTVs,
  GetWatchlistTVs,
])
void main() {
  const tTv = TV(
    backdropPath: 'backdropPath',
    firstAirDate: '2023-01-01',
    genreIds: [1],
    id: 1,
    name: 'name',
    originCountry: ['US'],
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
  );
  final tTvList = <TV>[tTv];

  group('AiringTodayTVsNotifier', () {
    late AiringTodayTVsNotifier provider;
    late MockGetAiringTodayTVs mockUsecase;
    late int listenerCallCount;

    setUp(() {
      listenerCallCount = 0;
      mockUsecase = MockGetAiringTodayTVs();
      provider = AiringTodayTVsNotifier(getAiringTodayTvs: mockUsecase)
        ..addListener(() {
          listenerCallCount++;
        });
    });

    test('initial state should be Empty', () {
      expect(provider.state, RequestState.empty);
    });

    test('should change to Loaded on success', () async {
      when(mockUsecase.execute()).thenAnswer((_) async => Right(tTvList));
      await provider.fetchAiringTodayTvs();
      expect(provider.state, RequestState.loaded);
      expect(provider.tvs, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should change to Error on failure', () async {
      when(mockUsecase.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Failed')));
      await provider.fetchAiringTodayTvs();
      expect(provider.state, RequestState.error);
      expect(provider.message, 'Failed');
    });
  });

  group('OnTheAirTVsNotifier', () {
    late OnTheAirTVsNotifier provider;
    late MockGetOnTheAirTVs mockUsecase;

    setUp(() {
      mockUsecase = MockGetOnTheAirTVs();
      provider = OnTheAirTVsNotifier(getOnTheAirTvs: mockUsecase);
    });

    test('initial state should be Empty', () {
      expect(provider.state, RequestState.empty);
    });

    test('should change to Loaded on success', () async {
      when(mockUsecase.execute()).thenAnswer((_) async => Right(tTvList));
      await provider.fetchOnTheAirTvs();
      expect(provider.state, RequestState.loaded);
      expect(provider.tvs, tTvList);
    });

    test('should change to Error on failure', () async {
      when(mockUsecase.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Failed')));
      await provider.fetchOnTheAirTvs();
      expect(provider.state, RequestState.error);
      expect(provider.message, 'Failed');
    });
  });

  group('PopularTVsNotifier', () {
    late PopularTVsNotifier provider;
    late MockGetPopularTVs mockUsecase;

    setUp(() {
      mockUsecase = MockGetPopularTVs();
      provider = PopularTVsNotifier(mockUsecase);
    });

    test('initial state should be Empty', () {
      expect(provider.state, RequestState.empty);
    });

    test('should change to Loaded on success', () async {
      when(mockUsecase.execute()).thenAnswer((_) async => Right(tTvList));
      await provider.fetchPopularTvs();
      expect(provider.state, RequestState.loaded);
      expect(provider.tvs, tTvList);
    });

    test('should change to Error on failure', () async {
      when(mockUsecase.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Failed')));
      await provider.fetchPopularTvs();
      expect(provider.state, RequestState.error);
      expect(provider.message, 'Failed');
    });
  });

  group('TopRatedTVsNotifier', () {
    late TopRatedTVsNotifier provider;
    late MockGetTopRatedTVs mockUsecase;

    setUp(() {
      mockUsecase = MockGetTopRatedTVs();
      provider = TopRatedTVsNotifier(getTopRatedTvs: mockUsecase);
    });

    test('initial state should be Empty', () {
      expect(provider.state, RequestState.empty);
    });

    test('should change to Loaded on success', () async {
      when(mockUsecase.execute()).thenAnswer((_) async => Right(tTvList));
      await provider.fetchTopRatedTvs();
      expect(provider.state, RequestState.loaded);
      expect(provider.tvs, tTvList);
    });

    test('should change to Error on failure', () async {
      when(mockUsecase.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Failed')));
      await provider.fetchTopRatedTvs();
      expect(provider.state, RequestState.error);
      expect(provider.message, 'Failed');
    });
  });

  group('TVSearchNotifier', () {
    late TVSearchNotifier provider;
    late MockSearchTVs mockUsecase;

    setUp(() {
      mockUsecase = MockSearchTVs();
      provider = TVSearchNotifier(searchTvs: mockUsecase);
    });

    test('initial state should be Empty', () {
      expect(provider.state, RequestState.empty);
    });

    test('should change to Loaded on success', () async {
      when(mockUsecase.execute('test')).thenAnswer((_) async => Right(tTvList));
      await provider.fetchTvSearch('test');
      expect(provider.state, RequestState.loaded);
      expect(provider.searchResult, tTvList);
    });

    test('should change to Error on failure', () async {
      when(mockUsecase.execute('test'))
          .thenAnswer((_) async => const Left(ServerFailure('Failed')));
      await provider.fetchTvSearch('test');
      expect(provider.state, RequestState.error);
      expect(provider.message, 'Failed');
    });
  });

  group('WatchlistTVNotifier', () {
    late WatchlistTVNotifier provider;
    late MockGetWatchlistTVs mockUsecase;

    setUp(() {
      mockUsecase = MockGetWatchlistTVs();
      provider = WatchlistTVNotifier(getWatchlistTvs: mockUsecase);
    });

    test('initial state should be Empty', () {
      expect(provider.watchlistState, RequestState.empty);
    });

    test('should change to Loaded on success', () async {
      when(mockUsecase.execute()).thenAnswer((_) async => Right(tTvList));
      await provider.fetchWatchlistTvs();
      expect(provider.watchlistState, RequestState.loaded);
      expect(provider.watchlistTvs, tTvList);
    });

    test('should change to Error on failure', () async {
      when(mockUsecase.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Failed')));
      await provider.fetchWatchlistTvs();
      expect(provider.watchlistState, RequestState.error);
      expect(provider.message, 'Failed');
    });
  });
}
