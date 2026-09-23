import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:ditonton_core/common/database_failure.dart';
import 'package:ditonton_core/common/server_failure.dart';
import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_core/domain/entities/genre.dart';
import 'package:ditonton_core/domain/entities/season.dart';
import 'package:ditonton_core/domain/entities/tv.dart';
import 'package:ditonton_core/domain/entities/tv_detail.dart';
import 'package:ditonton_tv/domain/usecases/get_season_detail.dart';
import 'package:ditonton_tv/domain/usecases/get_tv_detail.dart';
import 'package:ditonton_tv/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton_tv/domain/usecases/get_watchlist_tv_status.dart';
import 'package:ditonton_tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton_tv/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton_tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects_tv.dart';
import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTVDetail,
  GetTVRecommendations,
  GetSeasonDetail,
  GetWatchlistTVStatus,
  SaveWatchlistTV,
  RemoveWatchlistTV,
])
void main() {
  late TVDetailBloc bloc;
  late MockGetTVDetail mockGetTvDetail;
  late MockGetTVRecommendations mockGetTvRecommendations;
  late MockGetSeasonDetail mockGetSeasonDetail;
  late MockGetWatchlistTVStatus mockGetWatchlistTvStatus;
  late MockSaveWatchlistTV mockSaveWatchlistTv;
  late MockRemoveWatchlistTV mockRemoveWatchlistTv;
  late List<TVDetailState> emissions;
  late StreamSubscription<TVDetailState> sub;

  const tId = 1;

  const tTv = TV(
    backdropPath: 'backdropPath',
    firstAirDate: '2023-01-01',
    genreIds: [1, 2],
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
  final tTvs = <TV>[tTv];

  const tTvDetail = TVDetail(
    backdropPath: 'backdropPath',
    firstAirDate: '2021-01-01',
    genres: [Genre(id: 1, name: 'Drama')],
    id: 1,
    lastAirDate: '2023-01-01',
    name: 'name',
    numberOfEpisodes: 10,
    numberOfSeasons: 1,
    originalName: 'originalName',
    overview: 'overview',
    posterPath: 'posterPath',
    seasons: [
      Season(
        airDate: '2021-01-01',
        episodeCount: 10,
        id: 1,
        name: 'Season 1',
        overview: 'overview',
        posterPath: 'posterPath',
        seasonNumber: 1,
        voteAverage: 8.0,
      ),
    ],
    status: 'Returning Series',
    tagline: 'tagline',
    type: 'Scripted',
    voteAverage: 8.0,
    voteCount: 100,
  );

  setUp(() {
    emissions = [];
    mockGetTvDetail = MockGetTVDetail();
    mockGetTvRecommendations = MockGetTVRecommendations();
    mockGetSeasonDetail = MockGetSeasonDetail();
    mockGetWatchlistTvStatus = MockGetWatchlistTVStatus();
    mockSaveWatchlistTv = MockSaveWatchlistTV();
    mockRemoveWatchlistTv = MockRemoveWatchlistTV();
    bloc = TVDetailBloc(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
      getSeasonDetail: mockGetSeasonDetail,
      getWatchlistTvStatus: mockGetWatchlistTvStatus,
      saveWatchlistTv: mockSaveWatchlistTv,
      removeWatchlistTv: mockRemoveWatchlistTv,
    );
    sub = bloc.stream.listen(emissions.add);
  });

  tearDown(() async {
    await sub.cancel();
    await bloc.close();
  });

  Future<TVDetailState> waitForLast(bool Function(TVDetailState) test) {
    final completer = Completer<TVDetailState>();
    bloc.stream.listen((state) {
      if (test(state) && !completer.isCompleted) {
        completer.complete(state);
      }
    });
    return completer.future;
  }

  group('get tv detail', () {
    test('should change state to loading when usecase is called', () async {
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => const Right(testTvDetail));
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => Right(testTvList));
      bloc.add(FetchTVDetail(tId));
      final state = await waitForLast(
        (state) => state.tvState == RequestState.loading,
      );
      expect(state.tvState, RequestState.loading);
    });

    test('should change tv when data is gotten successfully', () async {
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => const Right(testTvDetail));
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => Right(testTvList));
      bloc.add(FetchTVDetail(tId));
      await waitForLast((state) => state.tvState == RequestState.loaded);
      expect(bloc.state.tvState, RequestState.loaded);
      expect(bloc.state.tv, testTvDetail);
      expect(bloc.state.recommendationState, RequestState.loaded);
      expect(bloc.state.tvRecommendations, testTvList);
    });

    test(
      'should change recommendation to error when recommendation fails',
      () async {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => const Right(testTvDetail));
        when(mockGetTvRecommendations.execute(tId))
            .thenAnswer((_) async => const Left(ServerFailure('Failed')));
        bloc.add(FetchTVDetail(tId));
        await waitForLast((state) => state.tvState == RequestState.loaded);
        expect(bloc.state.tvState, RequestState.loaded);
        expect(bloc.state.recommendationState, RequestState.error);
      },
    );

    test('should return error when data is unsuccessful', () async {
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTvs));
      bloc.add(FetchTVDetail(tId));
      await waitForLast((state) => state.tvState == RequestState.error);
      expect(bloc.state.tvState, RequestState.error);
      expect(bloc.state.message, 'Server Failure');
      expect(emissions.length, 2);
    });
  });

  group('season detail', () {
    test('should change season detail to loaded on success', () async {
      when(mockGetSeasonDetail.execute(tId, 1))
          .thenAnswer((_) async => const Right(testSeasonDetail));
      bloc.add(FetchSeasonDetail(tId, 1));
      await waitForLast(
        (state) => state.seasonDetailState == RequestState.loaded,
      );
      expect(bloc.state.seasonDetailState, RequestState.loaded);
      expect(bloc.state.seasonDetail, testSeasonDetail);
    });

    test('should change season detail to error on failure', () async {
      when(mockGetSeasonDetail.execute(tId, 1))
          .thenAnswer((_) async => const Left(ServerFailure('Failed')));
      bloc.add(FetchSeasonDetail(tId, 1));
      await waitForLast(
        (state) => state.seasonDetailState == RequestState.error,
      );
      expect(bloc.state.seasonDetailState, RequestState.error);
      expect(bloc.state.message, 'Failed');
    });
  });

  group('watchlist', () {
    test('should get the watchlist status', () async {
      when(mockGetWatchlistTvStatus.execute(1)).thenAnswer((_) async => true);
      bloc.add(LoadTVWatchlistStatus(1));
      await waitForLast((state) => state.isAddedToWatchlist == true);
      expect(bloc.state.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      when(mockSaveWatchlistTv.execute(tTvDetail))
          .thenAnswer((_) async => const Right('Added to Watchlist'));
      when(mockGetWatchlistTvStatus.execute(tTvDetail.id))
          .thenAnswer((_) async => true);
      bloc.add(AddTVWatchlist(tTvDetail));
      await waitForLast(
        (state) =>
            state.watchlistMessage == 'Added to Watchlist' &&
            state.isAddedToWatchlist == true,
      );
      verify(mockSaveWatchlistTv.execute(tTvDetail));
      expect(bloc.state.watchlistMessage, 'Added to Watchlist');
    });

    test('should execute save watchlist and handle error', () async {
      when(mockSaveWatchlistTv.execute(tTvDetail))
          .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistTvStatus.execute(tTvDetail.id))
          .thenAnswer((_) async => false);
      bloc.add(AddTVWatchlist(tTvDetail));
      await waitForLast((state) => state.watchlistMessage == 'Failed');
      expect(bloc.state.watchlistMessage, 'Failed');
    });

    test('should execute remove watchlist when function called', () async {
      when(mockRemoveWatchlistTv.execute(tTvDetail))
          .thenAnswer((_) async => const Right('Removed from Watchlist'));
      when(mockGetWatchlistTvStatus.execute(tTvDetail.id))
          .thenAnswer((_) async => false);
      bloc.add(RemoveTVWatchlist(tTvDetail));
      await waitForLast(
        (state) =>
            state.watchlistMessage == 'Removed from Watchlist' &&
            state.isAddedToWatchlist == false,
      );
      verify(mockRemoveWatchlistTv.execute(tTvDetail));
      expect(bloc.state.watchlistMessage, 'Removed from Watchlist');
    });

    test('should execute remove watchlist and handle error', () async {
      when(mockRemoveWatchlistTv.execute(tTvDetail))
          .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistTvStatus.execute(tTvDetail.id))
          .thenAnswer((_) async => true);
      bloc.add(RemoveTVWatchlist(tTvDetail));
      await waitForLast((state) => state.watchlistMessage == 'Failed');
      expect(bloc.state.watchlistMessage, 'Failed');
    });
  });
}
