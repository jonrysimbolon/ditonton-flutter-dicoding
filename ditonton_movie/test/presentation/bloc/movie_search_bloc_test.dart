import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:ditonton_core/common/server_failure.dart';
import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_core/domain/entities/movie.dart';
import 'package:ditonton_movie/domain/usecases/search_movies.dart';
import 'package:ditonton_movie/presentation/bloc/movie_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'movie_search_bloc_test.mocks.dart';

@GenerateMocks([SearchMovies])
void main() {
  late MovieSearchBloc bloc;
  late MockSearchMovies mockSearchMovies;
  late List<MovieSearchState> emissions;
  late StreamSubscription<MovieSearchState> sub;

  const tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview: 'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );
  final tMovieList = <Movie>[tMovieModel];
  const tQuery = 'spiderman';

  setUp(() {
    emissions = [];
    mockSearchMovies = MockSearchMovies();
    bloc = MovieSearchBloc(searchMovies: mockSearchMovies);
    sub = bloc.stream.listen(emissions.add);
  });

  tearDown(() async {
    await sub.cancel();
    await bloc.close();
  });

  Future<MovieSearchState> waitForLast(bool Function(MovieSearchState) test) {
    final completer = Completer<MovieSearchState>();
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

  group('search movies', () {
    test('should change state to loading when usecase is called', () async {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Right(tMovieList));
      bloc.add(FetchMovieSearch(tQuery));
      final state = await waitForLast(
        (state) => state.state == RequestState.loading,
      );
      expect(state.state, RequestState.loading);
    });

    test(
      'should change search result data when data is gotten successfully',
      () async {
        when(mockSearchMovies.execute(tQuery))
            .thenAnswer((_) async => Right(tMovieList));
        bloc.add(FetchMovieSearch(tQuery));
        await waitForLast((state) => state.state == RequestState.loaded);
        expect(bloc.state.state, RequestState.loaded);
        expect(bloc.state.searchResult, tMovieList);
        expect(emissions.length, 2);
      },
    );

    test('should return error when data is unsuccessful', () async {
      when(mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      bloc.add(FetchMovieSearch(tQuery));
      await waitForLast((state) => state.state == RequestState.error);
      expect(bloc.state.state, RequestState.error);
      expect(bloc.state.message, 'Server Failure');
      expect(emissions.length, 2);
    });
  });
}
