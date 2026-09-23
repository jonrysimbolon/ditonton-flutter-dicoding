import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:ditonton_core/common/server_failure.dart';
import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_core/domain/entities/tv.dart';
import 'package:ditonton_tv/domain/usecases/get_airing_today_tvs.dart';
import 'package:ditonton_tv/domain/usecases/get_on_the_air_tvs.dart';
import 'package:ditonton_tv/domain/usecases/get_popular_tvs.dart';
import 'package:ditonton_tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:ditonton_tv/presentation/bloc/tv_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_list_bloc_test.mocks.dart';

@GenerateMocks([
  GetAiringTodayTVs,
  GetOnTheAirTVs,
  GetPopularTVs,
  GetTopRatedTVs,
])
void main() {
  late TVListBloc bloc;
  late MockGetAiringTodayTVs mockGetAiringTodayTvs;
  late MockGetOnTheAirTVs mockGetOnTheAirTvs;
  late MockGetPopularTVs mockGetPopularTvs;
  late MockGetTopRatedTVs mockGetTopRatedTvs;
  late List<TVListState> emissions;
  late StreamSubscription<TVListState> sub;

  const tTv = TV(
    backdropPath: 'backdropPath',
    firstAirDate: '2023-01-01',
    genreIds: [1, 2, 3],
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

  setUp(() {
    emissions = [];
    mockGetAiringTodayTvs = MockGetAiringTodayTVs();
    mockGetOnTheAirTvs = MockGetOnTheAirTVs();
    mockGetPopularTvs = MockGetPopularTVs();
    mockGetTopRatedTvs = MockGetTopRatedTVs();
    bloc = TVListBloc(
      getAiringTodayTvs: mockGetAiringTodayTvs,
      getOnTheAirTvs: mockGetOnTheAirTvs,
      getPopularTvs: mockGetPopularTvs,
      getTopRatedTvs: mockGetTopRatedTvs,
    );
    sub = bloc.stream.listen(emissions.add);
  });

  tearDown(() async {
    await sub.cancel();
    await bloc.close();
  });

  Future<TVListState> waitForLast(bool Function(TVListState) test) {
    final completer = Completer<TVListState>();
    bloc.stream.listen((state) {
      if (test(state) && !completer.isCompleted) {
        completer.complete(state);
      }
    });
    return completer.future;
  }

  test('initialState should be Empty', () {
    expect(bloc.state.airingTodayState, equals(RequestState.empty));
    expect(bloc.state.onTheAirState, equals(RequestState.empty));
    expect(bloc.state.popularTvsState, equals(RequestState.empty));
    expect(bloc.state.topRatedTvsState, equals(RequestState.empty));
  });

  group('airing today tvs', () {
    test('should change state to Loading when usecase is called', () async {
      when(mockGetAiringTodayTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      bloc.add(const FetchAiringTodayTvsList());
      final state = await waitForLast(
        (state) => state.airingTodayState == RequestState.loading,
      );
      expect(state.airingTodayState, RequestState.loading);
    });

    test('should change tvs when data is gotten successfully', () async {
      when(mockGetAiringTodayTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      bloc.add(const FetchAiringTodayTvsList());
      await waitForLast(
        (state) => state.airingTodayState == RequestState.loaded,
      );
      expect(bloc.state.airingTodayState, RequestState.loaded);
      expect(bloc.state.airingTodayTvs, tTvList);
      expect(emissions.length, 2);
    });

    test('should return error when data is unsuccessful', () async {
      when(mockGetAiringTodayTvs.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      bloc.add(const FetchAiringTodayTvsList());
      await waitForLast(
        (state) => state.airingTodayState == RequestState.error,
      );
      expect(bloc.state.airingTodayState, RequestState.error);
      expect(bloc.state.message, 'Server Failure');
      expect(emissions.length, 2);
    });
  });

  group('on the air tvs', () {
    test('should change state to loading when usecase is called', () async {
      when(mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      bloc.add(const FetchOnTheAirTvsList());
      final state = await waitForLast(
        (state) => state.onTheAirState == RequestState.loading,
      );
      expect(state.onTheAirState, RequestState.loading);
    });

    test('should change tvs data when data is gotten successfully', () async {
      when(mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      bloc.add(const FetchOnTheAirTvsList());
      await waitForLast((state) => state.onTheAirState == RequestState.loaded);
      expect(bloc.state.onTheAirState, RequestState.loaded);
      expect(bloc.state.onTheAirTvs, tTvList);
      expect(emissions.length, 2);
    });

    test('should return error when data is unsuccessful', () async {
      when(mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      bloc.add(const FetchOnTheAirTvsList());
      await waitForLast((state) => state.onTheAirState == RequestState.error);
      expect(bloc.state.onTheAirState, RequestState.error);
      expect(bloc.state.message, 'Server Failure');
      expect(emissions.length, 2);
    });
  });

  group('popular tvs', () {
    test('should change state to loading when usecase is called', () async {
      when(mockGetPopularTvs.execute()).thenAnswer((_) async => Right(tTvList));
      bloc.add(const FetchPopularTvsList());
      final state = await waitForLast(
        (state) => state.popularTvsState == RequestState.loading,
      );
      expect(state.popularTvsState, RequestState.loading);
    });

    test('should change tvs data when data is gotten successfully', () async {
      when(mockGetPopularTvs.execute()).thenAnswer((_) async => Right(tTvList));
      bloc.add(const FetchPopularTvsList());
      await waitForLast(
        (state) => state.popularTvsState == RequestState.loaded,
      );
      expect(bloc.state.popularTvsState, RequestState.loaded);
      expect(bloc.state.popularTvs, tTvList);
      expect(emissions.length, 2);
    });

    test('should return error when data is unsuccessful', () async {
      when(mockGetPopularTvs.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      bloc.add(const FetchPopularTvsList());
      await waitForLast((state) => state.popularTvsState == RequestState.error);
      expect(bloc.state.popularTvsState, RequestState.error);
      expect(bloc.state.message, 'Server Failure');
      expect(emissions.length, 2);
    });
  });

  group('top rated tvs', () {
    test('should change state to loading when usecase is called', () async {
      when(mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      bloc.add(const FetchTopRatedTvsList());
      final state = await waitForLast(
        (state) => state.topRatedTvsState == RequestState.loading,
      );
      expect(state.topRatedTvsState, RequestState.loading);
    });

    test('should change tvs data when data is gotten successfully', () async {
      when(mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      bloc.add(const FetchTopRatedTvsList());
      await waitForLast(
        (state) => state.topRatedTvsState == RequestState.loaded,
      );
      expect(bloc.state.topRatedTvsState, RequestState.loaded);
      expect(bloc.state.topRatedTvs, tTvList);
      expect(emissions.length, 2);
    });

    test('should return error when data is unsuccessful', () async {
      when(mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      bloc.add(const FetchTopRatedTvsList());
      await waitForLast(
        (state) => state.topRatedTvsState == RequestState.error,
      );
      expect(bloc.state.topRatedTvsState, RequestState.error);
      expect(bloc.state.message, 'Server Failure');
      expect(emissions.length, 2);
    });
  });
}
