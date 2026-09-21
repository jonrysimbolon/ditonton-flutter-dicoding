import 'package:dartz/dartz.dart';
import 'package:ditonton/common/server_failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_airing_today_tvs.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tvs.dart';
import 'package:ditonton/domain/usecases/get_popular_tvs.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tvs.dart';
import 'package:ditonton/presentation/provider/tv_list_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_list_notifier_test.mocks.dart';

@GenerateMocks([
  GetAiringTodayTVs,
  GetOnTheAirTVs,
  GetPopularTVs,
  GetTopRatedTVs,
])
void main() {
  late TVListNotifier provider;
  late MockGetAiringTodayTVs mockGetAiringTodayTvs;
  late MockGetOnTheAirTVs mockGetOnTheAirTvs;
  late MockGetPopularTVs mockGetPopularTvs;
  late MockGetTopRatedTVs mockGetTopRatedTvs;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetAiringTodayTvs = MockGetAiringTodayTVs();
    mockGetOnTheAirTvs = MockGetOnTheAirTVs();
    mockGetPopularTvs = MockGetPopularTVs();
    mockGetTopRatedTvs = MockGetTopRatedTVs();
    provider =
        TVListNotifier(
          getAiringTodayTvs: mockGetAiringTodayTvs,
          getOnTheAirTvs: mockGetOnTheAirTvs,
          getPopularTvs: mockGetPopularTvs,
          getTopRatedTvs: mockGetTopRatedTvs,
        )..addListener(() {
          listenerCallCount += 1;
        });
  });

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

  group('airing today tvs', () {
    test('initialState should be Empty', () {
      expect(provider.airingTodayState, equals(RequestState.empty));
    });

    test('should change state to Loading when usecase is called', () {
      when(mockGetAiringTodayTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      provider.fetchAiringTodayTvs();
      expect(provider.airingTodayState, RequestState.loading);
    });

    test('should change tvs when data is gotten successfully', () async {
      when(mockGetAiringTodayTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      await provider.fetchAiringTodayTvs();
      expect(provider.airingTodayState, RequestState.loaded);
      expect(provider.airingTodayTvs, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      when(mockGetAiringTodayTvs.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      await provider.fetchAiringTodayTvs();
      expect(provider.airingTodayState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('on the air tvs', () {
    test('should change state to loading when usecase is called', () async {
      when(mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      provider.fetchOnTheAirTvs();
      expect(provider.onTheAirState, RequestState.loading);
    });

    test('should change tvs data when data is gotten successfully', () async {
      when(mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      await provider.fetchOnTheAirTvs();
      expect(provider.onTheAirState, RequestState.loaded);
      expect(provider.onTheAirTvs, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      when(mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      await provider.fetchOnTheAirTvs();
      expect(provider.onTheAirState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('popular tvs', () {
    test('should change state to loading when usecase is called', () async {
      when(mockGetPopularTvs.execute()).thenAnswer((_) async => Right(tTvList));
      provider.fetchPopularTvs();
      expect(provider.popularTvsState, RequestState.loading);
    });

    test('should change tvs data when data is gotten successfully', () async {
      when(mockGetPopularTvs.execute()).thenAnswer((_) async => Right(tTvList));
      await provider.fetchPopularTvs();
      expect(provider.popularTvsState, RequestState.loaded);
      expect(provider.popularTvs, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      when(mockGetPopularTvs.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      await provider.fetchPopularTvs();
      expect(provider.popularTvsState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });

  group('top rated tvs', () {
    test('should change state to loading when usecase is called', () async {
      when(mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      provider.fetchTopRatedTvs();
      expect(provider.topRatedTvsState, RequestState.loading);
    });

    test('should change tvs data when data is gotten successfully', () async {
      when(mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => Right(tTvList));
      await provider.fetchTopRatedTvs();
      expect(provider.topRatedTvsState, RequestState.loaded);
      expect(provider.topRatedTvs, tTvList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      when(mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      await provider.fetchTopRatedTvs();
      expect(provider.topRatedTvsState, RequestState.error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
