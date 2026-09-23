import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:ditonton_core/common/database_failure.dart';
import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_movie/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton_movie/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late WatchlistMovieBloc bloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late List<WatchlistMovieState> emissions;
  late StreamSubscription<WatchlistMovieState> sub;

  setUp(() {
    emissions = [];
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    bloc = WatchlistMovieBloc(getWatchlistMovies: mockGetWatchlistMovies);
    sub = bloc.stream.listen(emissions.add);
  });

  tearDown(() async {
    await sub.cancel();
    await bloc.close();
  });

  Future<WatchlistMovieState> waitForLast(
    bool Function(WatchlistMovieState) test,
  ) {
    final completer = Completer<WatchlistMovieState>();
    bloc.stream.listen((state) {
      if (test(state) && !completer.isCompleted) {
        completer.complete(state);
      }
    });
    return completer.future;
  }

  test('initialState should be Empty', () {
    expect(bloc.state.watchlistState, RequestState.empty);
  });

  test('should change movies data when data is gotten successfully', () async {
    when(mockGetWatchlistMovies.execute())
        .thenAnswer((_) async => const Right([testWatchlistMovie]));
    bloc.add(const FetchWatchlistMovies());
    await waitForLast((state) => state.watchlistState == RequestState.loaded);
    expect(bloc.state.watchlistState, RequestState.loaded);
    expect(bloc.state.watchlistMovies, [testWatchlistMovie]);
    expect(emissions.length, 2);
  });

  test('should return error when data is unsuccessful', () async {
    when(mockGetWatchlistMovies.execute())
        .thenAnswer((_) async => const Left(DatabaseFailure("Can't get data")));
    bloc.add(const FetchWatchlistMovies());
    await waitForLast((state) => state.watchlistState == RequestState.error);
    expect(bloc.state.watchlistState, RequestState.error);
    expect(bloc.state.message, "Can't get data");
    expect(emissions.length, 2);
  });
}
