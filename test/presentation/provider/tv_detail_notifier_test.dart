import 'package:dartz/dartz.dart';
import 'package:ditonton/common/database_failure.dart';
import 'package:ditonton/common/server_failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/get_season_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects_tv.dart';
import 'tv_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTVDetail,
  GetTVRecommendations,
  GetSeasonDetail,
  GetWatchlistTVStatus,
  SaveWatchlistTV,
  RemoveWatchlistTV,
])
void main() {
  late TVDetailNotifier provider;
  late MockGetTVDetail mockGetTvDetail;
  late MockGetTVRecommendations mockGetTvRecommendations;
  late MockGetSeasonDetail mockGetSeasonDetail;
  late MockGetWatchlistTVStatus mockGetWatchlistTvStatus;
  late MockSaveWatchlistTV mockSaveWatchlistTv;
  late MockRemoveWatchlistTV mockRemoveWatchlistTv;

  setUp(() {
    mockGetTvDetail = MockGetTVDetail();
    mockGetTvRecommendations = MockGetTVRecommendations();
    mockGetSeasonDetail = MockGetSeasonDetail();
    mockGetWatchlistTvStatus = MockGetWatchlistTVStatus();
    mockSaveWatchlistTv = MockSaveWatchlistTV();
    mockRemoveWatchlistTv = MockRemoveWatchlistTV();
    provider = TVDetailNotifier(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
      getSeasonDetail: mockGetSeasonDetail,
      getWatchlistTvStatus: mockGetWatchlistTvStatus,
      saveWatchlistTv: mockSaveWatchlistTv,
      removeWatchlistTv: mockRemoveWatchlistTv,
    );
  });

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

  group('get tv detail', () {
    test('should change state to loading when usecase is called', () async {
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => const Right(testTvDetail));
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => Right(testTvList));
      provider.fetchTvDetail(tId);
      expect(provider.tvState, RequestState.loading);
    });

    test('should change tv when data is gotten successfully', () async {
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => const Right(testTvDetail));
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => Right(testTvList));
      await provider.fetchTvDetail(tId);
      expect(provider.tvState, RequestState.loaded);
      expect(provider.tv, testTvDetail);
      expect(provider.recommendationState, RequestState.loaded);
      expect(provider.tvRecommendations, testTvList);
    });

    test(
      'should change recommendation to error when recommendation fails',
      () async {
        when(mockGetTvDetail.execute(tId))
            .thenAnswer((_) async => const Right(testTvDetail));
        when(mockGetTvRecommendations.execute(tId))
            .thenAnswer((_) async => const Left(ServerFailure('Failed')));
        await provider.fetchTvDetail(tId);
        expect(provider.tvState, RequestState.loaded);
        expect(provider.recommendationState, RequestState.error);
      },
    );

    test('should return error when data is unsuccessful', () async {
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTvs));
      await provider.fetchTvDetail(tId);
      expect(provider.tvState, RequestState.error);
      expect(provider.message, 'Server Failure');
    });
  });

  group('season detail', () {
    test('should change season detail to loaded on success', () async {
      when(mockGetSeasonDetail.execute(tId, 1))
          .thenAnswer((_) async => const Right(testSeasonDetail));
      await provider.fetchSeasonDetail(tId, 1);
      expect(provider.seasonDetailState, RequestState.loaded);
      expect(provider.seasonDetail, testSeasonDetail);
    });

    test('should change season detail to error on failure', () async {
      when(mockGetSeasonDetail.execute(tId, 1))
          .thenAnswer((_) async => const Left(ServerFailure('Failed')));
      await provider.fetchSeasonDetail(tId, 1);
      expect(provider.seasonDetailState, RequestState.error);
      expect(provider.message, 'Failed');
    });
  });

  group('watchlist', () {
    test('should get the watchlist status', () async {
      when(mockGetWatchlistTvStatus.execute(1)).thenAnswer((_) async => true);
      await provider.loadWatchlistStatus(1);
      expect(provider.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      when(mockSaveWatchlistTv.execute(tTvDetail))
          .thenAnswer((_) async => const Right('Added to Watchlist'));
      when(mockGetWatchlistTvStatus.execute(tTvDetail.id))
          .thenAnswer((_) async => true);
      await provider.addWatchlist(tTvDetail);
      verify(mockSaveWatchlistTv.execute(tTvDetail));
      expect(provider.watchlistMessage, 'Added to Watchlist');
    });

    test('should execute save watchlist and handle error', () async {
      when(mockSaveWatchlistTv.execute(tTvDetail))
          .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistTvStatus.execute(tTvDetail.id))
          .thenAnswer((_) async => false);
      await provider.addWatchlist(tTvDetail);
      expect(provider.watchlistMessage, 'Failed');
    });

    test('should execute remove watchlist when function called', () async {
      when(mockRemoveWatchlistTv.execute(tTvDetail))
          .thenAnswer((_) async => const Right('Removed from Watchlist'));
      when(mockGetWatchlistTvStatus.execute(tTvDetail.id))
          .thenAnswer((_) async => false);
      await provider.removeFromWatchlist(tTvDetail);
      verify(mockRemoveWatchlistTv.execute(tTvDetail));
      expect(provider.watchlistMessage, 'Removed from Watchlist');
    });

    test('should execute remove watchlist and handle error', () async {
      when(mockRemoveWatchlistTv.execute(tTvDetail))
          .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistTvStatus.execute(tTvDetail.id))
          .thenAnswer((_) async => true);
      await provider.removeFromWatchlist(tTvDetail);
      expect(provider.watchlistMessage, 'Failed');
    });
  });
}
