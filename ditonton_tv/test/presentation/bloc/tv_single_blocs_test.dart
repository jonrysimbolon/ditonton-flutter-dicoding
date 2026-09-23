import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:ditonton_core/common/server_failure.dart';
import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_core/domain/entities/tv.dart';
import 'package:ditonton_tv/domain/usecases/get_airing_today_tvs.dart';
import 'package:ditonton_tv/domain/usecases/get_on_the_air_tvs.dart';
import 'package:ditonton_tv/domain/usecases/get_popular_tvs.dart';
import 'package:ditonton_tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:ditonton_tv/domain/usecases/get_watchlist_tvs.dart';
import 'package:ditonton_tv/domain/usecases/search_tvs.dart';
import 'package:ditonton_tv/presentation/bloc/airing_today_tvs_bloc.dart';
import 'package:ditonton_tv/presentation/bloc/on_the_air_tvs_bloc.dart';
import 'package:ditonton_tv/presentation/bloc/popular_tvs_bloc.dart';
import 'package:ditonton_tv/presentation/bloc/top_rated_tvs_bloc.dart';
import 'package:ditonton_tv/presentation/bloc/tv_search_bloc.dart';
import 'package:ditonton_tv/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_single_blocs_test.mocks.dart';

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

  Future<T> waitForLast<T>(Stream<T> stream, bool Function(T) test) {
    final completer = Completer<T>();
    stream.listen((state) {
      if (test(state) && !completer.isCompleted) {
        completer.complete(state);
      }
    });
    return completer.future;
  }

  group('AiringTodayTVsBloc', () {
    late AiringTodayTVsBloc bloc;
    late MockGetAiringTodayTVs mockUsecase;
    late StreamSubscription<AiringTodayTVsState> sub;

    setUp(() {
      mockUsecase = MockGetAiringTodayTVs();
      bloc = AiringTodayTVsBloc(getAiringTodayTvs: mockUsecase);
      sub = bloc.stream.listen((_) {});
    });

    tearDown(() async {
      await sub.cancel();
      await bloc.close();
    });

    test('initial state should be Empty', () {
      expect(bloc.state.state, RequestState.empty);
    });

    test('should change to Loaded on success', () async {
      when(mockUsecase.execute()).thenAnswer((_) async => Right(tTvList));
      bloc.add(FetchAiringTodayTVs());
      await waitForLast(bloc.stream, (s) => s.state == RequestState.loaded);
      expect(bloc.state.state, RequestState.loaded);
      expect(bloc.state.tvs, tTvList);
    });

    test('should change to Error on failure', () async {
      when(mockUsecase.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Failed')));
      bloc.add(FetchAiringTodayTVs());
      await waitForLast(bloc.stream, (s) => s.state == RequestState.error);
      expect(bloc.state.state, RequestState.error);
      expect(bloc.state.message, 'Failed');
    });
  });

  group('OnTheAirTVsBloc', () {
    late OnTheAirTVsBloc bloc;
    late MockGetOnTheAirTVs mockUsecase;

    setUp(() {
      mockUsecase = MockGetOnTheAirTVs();
      bloc = OnTheAirTVsBloc(getOnTheAirTvs: mockUsecase);
    });

    tearDown(() => bloc.close());

    test('initial state should be Empty', () {
      expect(bloc.state.state, RequestState.empty);
    });

    test('should change to Loaded on success', () async {
      when(mockUsecase.execute()).thenAnswer((_) async => Right(tTvList));
      bloc.add(FetchOnTheAirTVs());
      await waitForLast(bloc.stream, (s) => s.state == RequestState.loaded);
      expect(bloc.state.state, RequestState.loaded);
      expect(bloc.state.tvs, tTvList);
    });

    test('should change to Error on failure', () async {
      when(mockUsecase.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Failed')));
      bloc.add(FetchOnTheAirTVs());
      await waitForLast(bloc.stream, (s) => s.state == RequestState.error);
      expect(bloc.state.state, RequestState.error);
      expect(bloc.state.message, 'Failed');
    });
  });

  group('PopularTVsBloc', () {
    late PopularTVsBloc bloc;
    late MockGetPopularTVs mockUsecase;

    setUp(() {
      mockUsecase = MockGetPopularTVs();
      bloc = PopularTVsBloc(mockUsecase);
    });

    tearDown(() => bloc.close());

    test('initial state should be Empty', () {
      expect(bloc.state.state, RequestState.empty);
    });

    test('should change to Loaded on success', () async {
      when(mockUsecase.execute()).thenAnswer((_) async => Right(tTvList));
      bloc.add(FetchPopularTVs());
      await waitForLast(bloc.stream, (s) => s.state == RequestState.loaded);
      expect(bloc.state.state, RequestState.loaded);
      expect(bloc.state.tvs, tTvList);
    });

    test('should change to Error on failure', () async {
      when(mockUsecase.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Failed')));
      bloc.add(FetchPopularTVs());
      await waitForLast(bloc.stream, (s) => s.state == RequestState.error);
      expect(bloc.state.state, RequestState.error);
      expect(bloc.state.message, 'Failed');
    });
  });

  group('TopRatedTVsBloc', () {
    late TopRatedTVsBloc bloc;
    late MockGetTopRatedTVs mockUsecase;

    setUp(() {
      mockUsecase = MockGetTopRatedTVs();
      bloc = TopRatedTVsBloc(getTopRatedTvs: mockUsecase);
    });

    tearDown(() => bloc.close());

    test('initial state should be Empty', () {
      expect(bloc.state.state, RequestState.empty);
    });

    test('should change to Loaded on success', () async {
      when(mockUsecase.execute()).thenAnswer((_) async => Right(tTvList));
      bloc.add(FetchTopRatedTVs());
      await waitForLast(bloc.stream, (s) => s.state == RequestState.loaded);
      expect(bloc.state.state, RequestState.loaded);
      expect(bloc.state.tvs, tTvList);
    });

    test('should change to Error on failure', () async {
      when(mockUsecase.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Failed')));
      bloc.add(FetchTopRatedTVs());
      await waitForLast(bloc.stream, (s) => s.state == RequestState.error);
      expect(bloc.state.state, RequestState.error);
      expect(bloc.state.message, 'Failed');
    });
  });

  group('TVSearchBloc', () {
    late TVSearchBloc bloc;
    late MockSearchTVs mockUsecase;

    setUp(() {
      mockUsecase = MockSearchTVs();
      bloc = TVSearchBloc(searchTvs: mockUsecase);
    });

    tearDown(() => bloc.close());

    test('initial state should be Empty', () {
      expect(bloc.state.state, RequestState.empty);
    });

    test('should change to Loaded on success', () async {
      when(mockUsecase.execute('test')).thenAnswer((_) async => Right(tTvList));
      bloc.add(FetchTVSearch('test'));
      await waitForLast(bloc.stream, (s) => s.state == RequestState.loaded);
      expect(bloc.state.state, RequestState.loaded);
      expect(bloc.state.searchResult, tTvList);
    });

    test('should change to Error on failure', () async {
      when(mockUsecase.execute('test'))
          .thenAnswer((_) async => const Left(ServerFailure('Failed')));
      bloc.add(FetchTVSearch('test'));
      await waitForLast(bloc.stream, (s) => s.state == RequestState.error);
      expect(bloc.state.state, RequestState.error);
      expect(bloc.state.message, 'Failed');
    });
  });

  group('WatchlistTVBloc', () {
    late WatchlistTVBloc bloc;
    late MockGetWatchlistTVs mockUsecase;

    setUp(() {
      mockUsecase = MockGetWatchlistTVs();
      bloc = WatchlistTVBloc(getWatchlistTvs: mockUsecase);
    });

    tearDown(() => bloc.close());

    test('initial state should be Empty', () {
      expect(bloc.state.watchlistState, RequestState.empty);
    });

    test('should change to Loaded on success', () async {
      when(mockUsecase.execute()).thenAnswer((_) async => Right(tTvList));
      bloc.add(const FetchWatchlistTVs());
      await waitForLast(
        bloc.stream,
        (s) => s.watchlistState == RequestState.loaded,
      );
      expect(bloc.state.watchlistState, RequestState.loaded);
      expect(bloc.state.watchlistTvs, tTvList);
    });

    test('should change to Error on failure', () async {
      when(mockUsecase.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Failed')));
      bloc.add(const FetchWatchlistTVs());
      await waitForLast(
        bloc.stream,
        (s) => s.watchlistState == RequestState.error,
      );
      expect(bloc.state.watchlistState, RequestState.error);
      expect(bloc.state.message, 'Failed');
    });
  });
}
