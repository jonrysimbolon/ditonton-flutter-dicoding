import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:ditonton_core/common/server_failure.dart';
import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_core/domain/entities/movie.dart';
import 'package:ditonton_movie/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton_movie/domain/usecases/get_popular_movies.dart';
import 'package:ditonton_movie/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton_movie/presentation/bloc/movie_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_list_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies, GetPopularMovies, GetTopRatedMovies])
void main() {
  late MovieListBloc bloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late List<MovieListState> emissions;
  late StreamSubscription<MovieListState> sub;

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
  final tMovieList = <Movie>[tMovie];

  setUp(() {
    emissions = [];
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    bloc = MovieListBloc(
      getNowPlayingMovies: mockGetNowPlayingMovies,
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
    );
    sub = bloc.stream.listen(emissions.add);
  });

  tearDown(() async {
    await sub.cancel();
    await bloc.close();
  });

  Future<MovieListState> waitForLast(bool Function(MovieListState) test) {
    final completer = Completer<MovieListState>();
    bloc.stream.listen((state) {
      if (test(state) && !completer.isCompleted) {
        completer.complete(state);
      }
    });
    return completer.future;
  }

  test('initialState should be Empty', () {
    expect(bloc.state.nowPlayingState, equals(RequestState.empty));
    expect(bloc.state.popularMoviesState, equals(RequestState.empty));
    expect(bloc.state.topRatedMoviesState, equals(RequestState.empty));
  });

  group('now playing movies', () {
    test('should get data from the usecase', () async {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      bloc.add(const FetchNowPlayingMovies());
      await waitForLast(
        (state) => state.nowPlayingState != RequestState.loading,
      );
      verify(mockGetNowPlayingMovies.execute());
    });

    test('should change state to Loading when usecase is called', () async {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      bloc.add(const FetchNowPlayingMovies());
      final state = await waitForLast(
        (state) => state.nowPlayingState == RequestState.loading,
      );
      expect(state.nowPlayingState, RequestState.loading);
    });

    test('should change movies when data is gotten successfully', () async {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      bloc.add(const FetchNowPlayingMovies());
      final state = await waitForLast(
        (state) => state.nowPlayingState == RequestState.loaded,
      );
      expect(bloc.state.nowPlayingState, RequestState.loaded);
      expect(bloc.state.nowPlayingMovies, tMovieList);
      expect(state.nowPlayingMovies, tMovieList);
      expect(emissions.length, 2);
    });

    test('should return error when data is unsuccessful', () async {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      bloc.add(const FetchNowPlayingMovies());
      await waitForLast((state) => state.nowPlayingState == RequestState.error);
      expect(bloc.state.nowPlayingState, RequestState.error);
      expect(bloc.state.message, 'Server Failure');
      expect(emissions.length, 2);
    });
  });

  group('popular movies', () {
    test('should change state to loading when usecase is called', () async {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      bloc.add(const FetchPopularMoviesList());
      final state = await waitForLast(
        (state) => state.popularMoviesState == RequestState.loading,
      );
      expect(state.popularMoviesState, RequestState.loading);
    });

    test(
      'should change movies data when data is gotten successfully',
      () async {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        bloc.add(const FetchPopularMoviesList());
        await waitForLast(
          (state) => state.popularMoviesState == RequestState.loaded,
        );
        expect(bloc.state.popularMoviesState, RequestState.loaded);
        expect(bloc.state.popularMovies, tMovieList);
        expect(emissions.length, 2);
      },
    );

    test('should return error when data is unsuccessful', () async {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      bloc.add(const FetchPopularMoviesList());
      await waitForLast(
        (state) => state.popularMoviesState == RequestState.error,
      );
      expect(bloc.state.popularMoviesState, RequestState.error);
      expect(bloc.state.message, 'Server Failure');
      expect(emissions.length, 2);
    });
  });

  group('top rated movies', () {
    test('should change state to loading when usecase is called', () async {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      bloc.add(const FetchTopRatedMoviesList());
      final state = await waitForLast(
        (state) => state.topRatedMoviesState == RequestState.loading,
      );
      expect(state.topRatedMoviesState, RequestState.loading);
    });

    test(
      'should change movies data when data is gotten successfully',
      () async {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        bloc.add(const FetchTopRatedMoviesList());
        await waitForLast(
          (state) => state.topRatedMoviesState == RequestState.loaded,
        );
        expect(bloc.state.topRatedMoviesState, RequestState.loaded);
        expect(bloc.state.topRatedMovies, tMovieList);
        expect(emissions.length, 2);
      },
    );

    test('should return error when data is unsuccessful', () async {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      bloc.add(const FetchTopRatedMoviesList());
      await waitForLast(
        (state) => state.topRatedMoviesState == RequestState.error,
      );
      expect(bloc.state.topRatedMoviesState, RequestState.error);
      expect(bloc.state.message, 'Server Failure');
      expect(emissions.length, 2);
    });
  });
}
