import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:ditonton_core/common/server_failure.dart';
import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_core/domain/entities/movie.dart';
import 'package:ditonton_movie/domain/usecases/get_popular_movies.dart';
import 'package:ditonton_movie/presentation/bloc/popular_movies_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_movies_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late PopularMoviesBloc bloc;
  late MockGetPopularMovies mockGetPopularMovies;
  late List<PopularMoviesState> emissions;
  late StreamSubscription<PopularMoviesState> sub;

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
    mockGetPopularMovies = MockGetPopularMovies();
    bloc = PopularMoviesBloc(mockGetPopularMovies);
    sub = bloc.stream.listen(emissions.add);
  });

  tearDown(() async {
    await sub.cancel();
    await bloc.close();
  });

  Future<PopularMoviesState> waitForLast(
    bool Function(PopularMoviesState) test,
  ) {
    final completer = Completer<PopularMoviesState>();
    bloc.stream.listen((state) {
      if (test(state) && !completer.isCompleted) {
        completer.complete(state);
      }
    });
    return completer.future;
  }

  test('initialState should be Empty', () {
    expect(bloc.state.state, RequestState.empty);
  });

  test('should change state to loading when usecase is called', () async {
    when(mockGetPopularMovies.execute())
        .thenAnswer((_) async => Right(tMovieList));
    bloc.add(FetchPopularMovies());
    final state = await waitForLast(
      (state) => state.state == RequestState.loading,
    );
    expect(state.state, RequestState.loading);
  });

  test('should change movies data when data is gotten successfully', () async {
    when(mockGetPopularMovies.execute())
        .thenAnswer((_) async => Right(tMovieList));
    bloc.add(FetchPopularMovies());
    await waitForLast((state) => state.state == RequestState.loaded);
    expect(bloc.state.state, RequestState.loaded);
    expect(bloc.state.movies, tMovieList);
    expect(emissions.length, 2);
  });

  test('should return error when data is unsuccessful', () async {
    when(mockGetPopularMovies.execute())
        .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
    bloc.add(FetchPopularMovies());
    await waitForLast((state) => state.state == RequestState.error);
    expect(bloc.state.state, RequestState.error);
    expect(bloc.state.message, 'Server Failure');
    expect(emissions.length, 2);
  });
}
