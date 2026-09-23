import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:ditonton_core/common/database_failure.dart';
import 'package:ditonton_core/common/server_failure.dart';
import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_core/domain/entities/movie.dart';
import 'package:ditonton_movie/domain/usecases/get_movie_detail.dart';
import 'package:ditonton_movie/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton_movie/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton_movie/domain/usecases/remove_watchlist.dart';
import 'package:ditonton_movie/domain/usecases/save_watchlist.dart';
import 'package:ditonton_movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MovieDetailBloc bloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatus mockGetWatchlistStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late List<MovieDetailState> emissions;
  late StreamSubscription<MovieDetailState> sub;

  const tId = 1;

  const tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovies = <Movie>[tMovie];

  void arrangeUsecase() {
    when(mockGetMovieDetail.execute(tId))
        .thenAnswer((_) async => const Right(testMovieDetail));
    when(mockGetMovieRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tMovies));
  }

  setUp(() {
    emissions = [];
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    bloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchlistStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
    sub = bloc.stream.listen(emissions.add);
  });

  tearDown(() async {
    await sub.cancel();
    await bloc.close();
  });

  Future<MovieDetailState> waitForLast(bool Function(MovieDetailState) test) {
    final completer = Completer<MovieDetailState>();
    bloc.stream.listen((state) {
      if (test(state) && !completer.isCompleted) {
        completer.complete(state);
      }
    });
    return completer.future;
  }

  Future<void> waitForEmissions(int count) {
    final completer = Completer<void>();
    bloc.stream.listen((state) {
      if (emissions.length >= count && !completer.isCompleted) {
        completer.complete();
      }
    });
    return completer.future;
  }

  group('Get Movie Detail', () {
    test('should get data from the usecase', () async {
      arrangeUsecase();
      bloc.add(FetchMovieDetail(tId));
      await waitForLast((state) => state.movieState == RequestState.loaded);
      verify(mockGetMovieDetail.execute(tId));
      verify(mockGetMovieRecommendations.execute(tId));
    });

    test('should change state to Loading when usecase is called', () async {
      arrangeUsecase();
      bloc.add(FetchMovieDetail(tId));
      final state = await waitForLast(
        (state) => state.movieState == RequestState.loading,
      );
      expect(state.movieState, RequestState.loading);
    });

    test('should change movie when data is gotten successfully', () async {
      arrangeUsecase();
      bloc.add(FetchMovieDetail(tId));
      await waitForLast((state) => state.movieState == RequestState.loaded);
      expect(bloc.state.movieState, RequestState.loaded);
      expect(bloc.state.movie, testMovieDetail);
      expect(emissions.length, 4);
    });

    test(
      'should change recommendation movies when data is gotten successfully',
      () async {
        arrangeUsecase();
        bloc.add(FetchMovieDetail(tId));
        await waitForLast((state) => state.movieState == RequestState.loaded);
        expect(bloc.state.movieState, RequestState.loaded);
        expect(bloc.state.movieRecommendations, tMovies);
      },
    );
  });

  group('Get Movie Recommendations', () {
    test('should get data from the usecase', () async {
      arrangeUsecase();
      bloc.add(FetchMovieDetail(tId));
      await waitForLast((state) => state.movieState == RequestState.loaded);
      verify(mockGetMovieRecommendations.execute(tId));
      expect(bloc.state.movieRecommendations, tMovies);
    });

    test(
      'should update recommendation state when data is gotten successfully',
      () async {
        arrangeUsecase();
        bloc.add(FetchMovieDetail(tId));
        await waitForLast((state) => state.movieState == RequestState.loaded);
        expect(bloc.state.recommendationState, RequestState.loaded);
        expect(bloc.state.movieRecommendations, tMovies);
      },
    );

    test('should update error message when request is unsuccessful', () async {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => const Right(testMovieDetail));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Failed')));
      bloc.add(FetchMovieDetail(tId));
      await waitForLast((state) => state.movieState == RequestState.loaded);
      expect(bloc.state.recommendationState, RequestState.error);
      expect(bloc.state.message, 'Failed');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      when(mockGetWatchlistStatus.execute(1)).thenAnswer((_) async => true);
      bloc.add(LoadMovieWatchlistStatus(1));
      await waitForLast((state) => state.isAddedToWatchlist == true);
      expect(bloc.state.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => const Right('Success'));
      when(mockGetWatchlistStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => true);
      bloc.add(AddMovieWatchlist(testMovieDetail));
      await waitForLast(
        (state) =>
            state.isAddedToWatchlist == true &&
            state.watchlistMessage == 'Success',
      );
      verify(mockSaveWatchlist.execute(testMovieDetail));
    });

    test('should execute remove watchlist when function called', () async {
      when(mockRemoveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => const Right('Removed'));
      when(mockGetWatchlistStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => false);
      bloc.add(RemoveMovieWatchlist(testMovieDetail));
      await waitForLast(
        (state) =>
            state.isAddedToWatchlist == false &&
            state.watchlistMessage == 'Removed',
      );
      verify(mockRemoveWatchlist.execute(testMovieDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => const Right('Added to Watchlist'));
      when(mockGetWatchlistStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => true);
      bloc.add(AddMovieWatchlist(testMovieDetail));
      await waitForLast(
        (state) =>
            state.isAddedToWatchlist == true &&
            state.watchlistMessage ==
                MovieDetailState.watchlistAddSuccessMessage,
      );
      verify(mockGetWatchlistStatus.execute(testMovieDetail.id));
      expect(bloc.state.isAddedToWatchlist, true);
      expect(bloc.state.watchlistMessage, 'Added to Watchlist');
      expect(emissions.length, 2);
    });

    test('should update watchlist message when add watchlist failed', () async {
      when(mockSaveWatchlist.execute(testMovieDetail))
          .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => false);
      bloc.add(AddMovieWatchlist(testMovieDetail));
      await waitForLast((state) => state.watchlistMessage == 'Failed');
      expect(bloc.state.watchlistMessage, 'Failed');
      expect(emissions.length, 1);
    });

    test(
      'should update watchlist message when remove watchlist failed',
      () async {
        when(mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(mockGetWatchlistStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        bloc.add(RemoveMovieWatchlist(testMovieDetail));
        await waitForEmissions(2);
        expect(bloc.state.watchlistMessage, 'Failed');
        expect(emissions.length, 2);
      },
    );
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tMovies));
      bloc.add(FetchMovieDetail(tId));
      await waitForLast((state) => state.movieState == RequestState.error);
      expect(bloc.state.movieState, RequestState.error);
      expect(bloc.state.message, 'Server Failure');
      expect(emissions.length, 2);
    });
  });
}
