import 'dart:async';

import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_core/common/utils.dart';
import 'package:ditonton_movie/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:ditonton_movie/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton_movie/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_movies_page_test.mocks.dart';

@GenerateMocks([WatchlistMovieBloc])
void main() {
  group('WatchlistMoviesPage', () {
    test('events support value equality', () {
      expect(const WatchlistMovieEvent(), const WatchlistMovieEvent());
    });
    late MockWatchlistMovieBloc mockBloc;
    late StreamController<WatchlistMovieState> streamController;

    setUp(() {
      mockBloc = MockWatchlistMovieBloc();
      streamController = StreamController<WatchlistMovieState>.broadcast();
      when(mockBloc.stream).thenAnswer((_) => streamController.stream);
    });

    tearDown(() {
      streamController.close();
    });

    Widget makeTestable() {
      return BlocProvider<WatchlistMovieBloc>.value(
        value: mockBloc,
        child: MaterialApp(
          home: const WatchlistMoviesPage(),
          navigatorObservers: [routeObserver],
        ),
      );
    }

    testWidgets('shows progress bar when loading', (tester) async {
      when(mockBloc.state).thenReturn(
        const WatchlistMovieState(watchlistState: RequestState.loading),
      );

      await tester.pumpWidget(makeTestable());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message', (tester) async {
      when(mockBloc.state).thenReturn(
        const WatchlistMovieState(
          watchlistState: RequestState.error,
          message: 'Error message',
        ),
      );

      await tester.pumpWidget(makeTestable());

      expect(find.byKey(const Key('error_message')), findsOneWidget);
    });

    testWidgets('shows list when loaded with data', (tester) async {
      when(mockBloc.state).thenReturn(
        const WatchlistMovieState(
          watchlistState: RequestState.loaded,
          watchlistMovies: [testWatchlistMovie],
        ),
      );

      await tester.pumpWidget(makeTestable());
      await tester.pump();

      expect(find.byType(MovieCard), findsOneWidget);
    });

    testWidgets('refreshes when returning from another route', (tester) async {
      when(mockBloc.state).thenReturn(
        const WatchlistMovieState(watchlistState: RequestState.loaded),
      );

      await tester.pumpWidget(makeTestable());
      await tester.pump();

      final context = tester.element(find.byType(WatchlistMoviesPage));
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const Scaffold()));
      await tester.pumpAndSettle();
      Navigator.of(context).pop();
      await tester.pumpAndSettle();

      verify(mockBloc.add(const FetchWatchlistMovies()))
          .called(greaterThanOrEqualTo(1));
    });
  });
}
