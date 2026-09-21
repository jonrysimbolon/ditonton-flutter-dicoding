import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/connection_failure.dart';
import 'package:ditonton/common/database_exception.dart';
import 'package:ditonton/common/database_failure.dart';
import 'package:ditonton/common/server_exception.dart';
import 'package:ditonton/common/server_failure.dart';
import 'package:ditonton/data/models/episode_model.dart';
import 'package:ditonton/data/models/season_detail_model.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/repositories/tv_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects_tv.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TVRepositoryImpl repository;
  late MockTVRemoteDataSource mockRemoteDataSource;
  late MockTVLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTVRemoteDataSource();
    mockLocalDataSource = MockTVLocalDataSource();
    repository = TVRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  const tTvModel = TVModel(
    backdropPath: '/backdrop1.jpg',
    firstAirDate: '2023-01-01',
    genreIds: [18, 80],
    id: 100,
    name: 'Test TV Airing Today',
    originCountry: ['US'],
    originalName: 'Test TV Airing Today',
    overview: 'Overview airing today tv series for testing.',
    popularity: 100.5,
    posterPath: '/poster1.jpg',
    voteAverage: 8.5,
    voteCount: 1000,
  );

  final tTvModelList = <TVModel>[tTvModel];
  final tTvList = [testTv];

  group('Airing Today TVs', () {
    test('should return remote data when call is successful', () async {
      when(mockRemoteDataSource.getAiringTodayTvs())
          .thenAnswer((_) async => tTvModelList);
      final result = await repository.getAiringTodayTvs();
      verify(mockRemoteDataSource.getAiringTodayTvs());
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test('should return ServerFailure when call is unsuccessful', () async {
      when(mockRemoteDataSource.getAiringTodayTvs())
          .thenThrow(ServerException());
      final result = await repository.getAiringTodayTvs();
      verify(mockRemoteDataSource.getAiringTodayTvs());
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test('should return ConnectionFailure when device is offline', () async {
      when(mockRemoteDataSource.getAiringTodayTvs())
          .thenThrow(const SocketException('Failed to connect to the network'));
      final result = await repository.getAiringTodayTvs();
      verify(mockRemoteDataSource.getAiringTodayTvs());
      expect(
        result,
        equals(
          const Left(ConnectionFailure('Failed to connect to the network')),
        ),
      );
    });
  });

  group('On The Air TVs', () {
    test('should return remote data when call is successful', () async {
      when(mockRemoteDataSource.getOnTheAirTvs())
          .thenAnswer((_) async => tTvModelList);
      final result = await repository.getOnTheAirTvs();
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test('should return ServerFailure when call is unsuccessful', () async {
      when(mockRemoteDataSource.getOnTheAirTvs()).thenThrow(ServerException());
      final result = await repository.getOnTheAirTvs();
      expect(result, const Left(ServerFailure('')));
    });

    test('should return ConnectionFailure when device is offline', () async {
      when(mockRemoteDataSource.getOnTheAirTvs())
          .thenThrow(const SocketException('Failed to connect to the network'));
      final result = await repository.getOnTheAirTvs();
      expect(
        result,
        equals(
          const Left(ConnectionFailure('Failed to connect to the network')),
        ),
      );
    });
  });

  group('Popular TVs', () {
    test('should return remote data when call is successful', () async {
      when(mockRemoteDataSource.getPopularTvs())
          .thenAnswer((_) async => tTvModelList);
      final result = await repository.getPopularTvs();
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test('should return ServerFailure when call is unsuccessful', () async {
      when(mockRemoteDataSource.getPopularTvs()).thenThrow(ServerException());
      final result = await repository.getPopularTvs();
      expect(result, const Left(ServerFailure('')));
    });

    test('should return ConnectionFailure when device is offline', () async {
      when(mockRemoteDataSource.getPopularTvs())
          .thenThrow(const SocketException('Failed to connect to the network'));
      final result = await repository.getPopularTvs();
      expect(
        result,
        equals(
          const Left(ConnectionFailure('Failed to connect to the network')),
        ),
      );
    });
  });

  group('Top Rated TVs', () {
    test('should return remote data when call is successful', () async {
      when(mockRemoteDataSource.getTopRatedTvs())
          .thenAnswer((_) async => tTvModelList);
      final result = await repository.getTopRatedTvs();
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test('should return ServerFailure when call is unsuccessful', () async {
      when(mockRemoteDataSource.getTopRatedTvs()).thenThrow(ServerException());
      final result = await repository.getTopRatedTvs();
      expect(result, const Left(ServerFailure('')));
    });

    test('should return ConnectionFailure when device is offline', () async {
      when(mockRemoteDataSource.getTopRatedTvs())
          .thenThrow(const SocketException('Failed to connect to the network'));
      final result = await repository.getTopRatedTvs();
      expect(
        result,
        equals(
          const Left(ConnectionFailure('Failed to connect to the network')),
        ),
      );
    });
  });

  group('Get TV Detail', () {
    const tId = 1;
    const tDetailModel = TVDetailModel(
      backdropPath: '/backdrop_detail.jpg',
      firstAirDate: '2021-01-01',
      genres: [],
      id: 1,
      lastAirDate: '2023-01-01',
      name: 'Test TV Detail',
      numberOfEpisodes: 20,
      numberOfSeasons: 2,
      originalName: 'Test TV Detail',
      overview: 'Detailed overview of test tv series.',
      posterPath: '/poster_detail.jpg',
      seasons: [],
      status: 'Returning Series',
      tagline: 'Test tagline',
      type: 'Scripted',
      voteAverage: 8.7,
      voteCount: 1500,
    );

    test('should return TVDetail when call is successful', () async {
      when(mockRemoteDataSource.getTvDetail(tId))
          .thenAnswer((_) async => tDetailModel);
      final result = await repository.getTvDetail(tId);
      verify(mockRemoteDataSource.getTvDetail(tId));
      expect(result.isRight(), true);
    });

    test('should return ServerFailure when call is unsuccessful', () async {
      when(mockRemoteDataSource.getTvDetail(tId)).thenThrow(ServerException());
      final result = await repository.getTvDetail(tId);
      verify(mockRemoteDataSource.getTvDetail(tId));
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test('should return ConnectionFailure when device is offline', () async {
      when(mockRemoteDataSource.getTvDetail(tId))
          .thenThrow(const SocketException('Failed to connect to the network'));
      final result = await repository.getTvDetail(tId);
      verify(mockRemoteDataSource.getTvDetail(tId));
      expect(
        result,
        equals(
          const Left(ConnectionFailure('Failed to connect to the network')),
        ),
      );
    });
  });

  group('Get TV Recommendations', () {
    const tId = 1;

    test('should return list when call is successful', () async {
      when(mockRemoteDataSource.getTvRecommendations(tId))
          .thenAnswer((_) async => tTvModelList);
      final result = await repository.getTvRecommendations(tId);
      verify(mockRemoteDataSource.getTvRecommendations(tId));
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tTvList));
    });

    test('should return ServerFailure when call is unsuccessful', () async {
      when(mockRemoteDataSource.getTvRecommendations(tId))
          .thenThrow(ServerException());
      final result = await repository.getTvRecommendations(tId);
      verify(mockRemoteDataSource.getTvRecommendations(tId));
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test('should return ConnectionFailure when device is offline', () async {
      when(mockRemoteDataSource.getTvRecommendations(tId))
          .thenThrow(const SocketException('Failed to connect to the network'));
      final result = await repository.getTvRecommendations(tId);
      verify(mockRemoteDataSource.getTvRecommendations(tId));
      expect(
        result,
        equals(
          const Left(ConnectionFailure('Failed to connect to the network')),
        ),
      );
    });
  });

  group('Get Season Detail', () {
    const tId = 1;
    const tSeason = 1;
    const tSeasonModel = SeasonDetailModel(
      airDate: '2021-01-01',
      episodes: [
        EpisodeModel(
          airDate: '2021-01-01',
          episodeNumber: 1,
          id: 5001,
          name: 'Pilot',
          overview: 'Pilot episode overview.',
          runtime: 55,
          seasonNumber: 1,
          stillPath: '/still1.jpg',
          voteAverage: 8.0,
          voteCount: 100,
        ),
        EpisodeModel(
          airDate: '2021-01-08',
          episodeNumber: 2,
          id: 5002,
          name: 'Second Episode',
          overview: 'Second episode overview.',
          runtime: 50,
          seasonNumber: 1,
          stillPath: '/still2.jpg',
          voteAverage: 8.3,
          voteCount: 90,
        ),
      ],
      id: 1001,
      name: 'Season 1',
      overview: 'Season 1 overview.',
      posterPath: '/season1.jpg',
      seasonNumber: 1,
    );

    test('should return SeasonDetail when call is successful', () async {
      when(mockRemoteDataSource.getSeasonDetail(tId, tSeason))
          .thenAnswer((_) async => tSeasonModel);
      final result = await repository.getSeasonDetail(tId, tSeason);
      verify(mockRemoteDataSource.getSeasonDetail(tId, tSeason));
      expect(result, equals(const Right(testSeasonDetail)));
    });

    test('should return ServerFailure when call is unsuccessful', () async {
      when(mockRemoteDataSource.getSeasonDetail(tId, tSeason))
          .thenThrow(ServerException());
      final result = await repository.getSeasonDetail(tId, tSeason);
      verify(mockRemoteDataSource.getSeasonDetail(tId, tSeason));
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test('should return ConnectionFailure when device is offline', () async {
      when(mockRemoteDataSource.getSeasonDetail(tId, tSeason))
          .thenThrow(const SocketException('Failed to connect to the network'));
      final result = await repository.getSeasonDetail(tId, tSeason);
      verify(mockRemoteDataSource.getSeasonDetail(tId, tSeason));
      expect(
        result,
        equals(
          const Left(ConnectionFailure('Failed to connect to the network')),
        ),
      );
    });
  });

  group('Search TVs', () {
    const tQuery = 'test';

    test('should return list when call is successful', () async {
      when(mockRemoteDataSource.searchTvs(tQuery))
          .thenAnswer((_) async => tTvModelList);
      final result = await repository.searchTvs(tQuery);
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });

    test('should return ServerFailure when call is unsuccessful', () async {
      when(mockRemoteDataSource.searchTvs(tQuery)).thenThrow(ServerException());
      final result = await repository.searchTvs(tQuery);
      expect(result, const Left(ServerFailure('')));
    });

    test('should return ConnectionFailure when device is offline', () async {
      when(mockRemoteDataSource.searchTvs(tQuery))
          .thenThrow(const SocketException('Failed to connect to the network'));
      final result = await repository.searchTvs(tQuery);
      expect(
        result,
        equals(
          const Left(ConnectionFailure('Failed to connect to the network')),
        ),
      );
    });
  });

  group('save watchlist', () {
    test('should return success message when saving successful', () async {
      when(mockLocalDataSource.insertTvWatchlist(testTvTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      final result = await repository.saveWatchlist(testTvDetail);
      expect(result, const Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      when(mockLocalDataSource.insertTvWatchlist(testTvTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      final result = await repository.saveWatchlist(testTvDetail);
      expect(result, const Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove successful', () async {
      when(mockLocalDataSource.removeTvWatchlist(testTvTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      final result = await repository.removeWatchlist(testTvDetail);
      expect(result, const Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove unsuccessful', () async {
      when(mockLocalDataSource.removeTvWatchlist(testTvTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      final result = await repository.removeWatchlist(testTvDetail);
      expect(result, const Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return false when data is not found', () async {
      const tId = 1;
      when(mockLocalDataSource.getTvById(tId)).thenAnswer((_) async => null);
      final result = await repository.isAddedToWatchlist(tId);
      expect(result, false);
    });

    test('should return true when data is found', () async {
      const tId = 1;
      when(mockLocalDataSource.getTvById(tId))
          .thenAnswer((_) async => testTvTable);
      final result = await repository.isAddedToWatchlist(tId);
      expect(result, true);
    });
  });

  group('get watchlist tvs', () {
    test('should return list of TVs', () async {
      when(mockLocalDataSource.getWatchlistTvs())
          .thenAnswer((_) async => [testTvTable]);
      final result = await repository.getWatchlistTvs();
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTv]);
    });
  });
}
