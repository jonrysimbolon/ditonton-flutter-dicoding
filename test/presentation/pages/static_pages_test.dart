import 'dart:async';

import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_movie/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:ditonton_tv/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:ditonton_movie/presentation/widgets/movie_card_list.dart';
import 'package:ditonton_tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../dummy_data/dummy_objects_tv.dart';
import 'static_pages_test.mocks.dart';

@GenerateMocks([WatchlistMovieBloc, WatchlistTVBloc])
void main() {
  group('WatchlistPage', () {
    late MockWatchlistMovieBloc mockWatchlistMovieBloc;
    late MockWatchlistTVBloc mockWatchlistTvBloc;
    late StreamController<WatchlistMovieState> movieStreamController;
    late StreamController<WatchlistTVState> tvStreamController;

    setUp(() {
      mockWatchlistMovieBloc = MockWatchlistMovieBloc();
      mockWatchlistTvBloc = MockWatchlistTVBloc();
      movieStreamController = StreamController<WatchlistMovieState>.broadcast();
      tvStreamController = StreamController<WatchlistTVState>.broadcast();
      when(mockWatchlistMovieBloc.stream)
          .thenAnswer((_) => movieStreamController.stream);
      when(mockWatchlistTvBloc.stream)
          .thenAnswer((_) => tvStreamController.stream);
      when(mockWatchlistMovieBloc.state).thenReturn(
        const WatchlistMovieState(watchlistState: RequestState.loaded),
      );
      when(
        mockWatchlistTvBloc.state,
      ).thenReturn(const WatchlistTVState(watchlistState: RequestState.loaded));
    });

    tearDown(() {
      movieStreamController.close();
      tvStreamController.close();
    });

    testWidgets('shows cards in both tabs when loaded with data', (
      tester,
    ) async {
      when(mockWatchlistMovieBloc.state).thenReturn(
        const WatchlistMovieState(
          watchlistState: RequestState.loaded,
          watchlistMovies: [testWatchlistMovie],
        ),
      );
      when(mockWatchlistTvBloc.state).thenReturn(
        const WatchlistTVState(
          watchlistState: RequestState.loaded,
          watchlistTvs: [testWatchlistTv],
        ),
      );

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<WatchlistMovieBloc>.value(
              value: mockWatchlistMovieBloc,
            ),
            BlocProvider<WatchlistTVBloc>.value(value: mockWatchlistTvBloc),
          ],
          child: const MaterialApp(home: WatchlistPage()),
        ),
      );
      await tester.pump();

      expect(find.byType(MovieCard), findsOneWidget);

      await tester.tap(find.text('TV Series'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.byType(TVCard), findsOneWidget);
    });

    testWidgets('shows error message in both tabs', (tester) async {
      when(mockWatchlistMovieBloc.state).thenReturn(
        const WatchlistMovieState(
          watchlistState: RequestState.error,
          message: 'Movie error',
        ),
      );
      when(mockWatchlistTvBloc.state).thenReturn(
        const WatchlistTVState(
          watchlistState: RequestState.error,
          message: 'TV error',
        ),
      );

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<WatchlistMovieBloc>.value(
              value: mockWatchlistMovieBloc,
            ),
            BlocProvider<WatchlistTVBloc>.value(value: mockWatchlistTvBloc),
          ],
          child: const MaterialApp(home: WatchlistPage()),
        ),
      );
      await tester.pump();

      expect(find.byKey(const Key('error_message_movie')), findsOneWidget);
      expect(find.text('Movie error'), findsOneWidget);

      await tester.tap(find.text('TV Series'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('error_message_tv')), findsOneWidget);
      expect(find.text('TV error'), findsOneWidget);
    });

    testWidgets('shows tabs and empty states for both lists', (tester) async {
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<WatchlistMovieBloc>.value(
              value: mockWatchlistMovieBloc,
            ),
            BlocProvider<WatchlistTVBloc>.value(value: mockWatchlistTvBloc),
          ],
          child: const MaterialApp(home: WatchlistPage()),
        ),
      );
      await tester.pump();

      expect(find.text('Watchlist'), findsWidgets);
      expect(find.byKey(const Key('empty_watchlist_movies')), findsOneWidget);

      await tester.tap(find.text('TV Series'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('empty_watchlist_tv')), findsOneWidget);
    });

    testWidgets('refetches both watchlists when the page is resumed', (
      tester,
    ) async {
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<WatchlistMovieBloc>.value(
              value: mockWatchlistMovieBloc,
            ),
            BlocProvider<WatchlistTVBloc>.value(value: mockWatchlistTvBloc),
          ],
          child: const MaterialApp(home: WatchlistPage()),
        ),
      );
      await tester.pump();
      clearInteractions(mockWatchlistMovieBloc);
      clearInteractions(mockWatchlistTvBloc);

      final dynamic state = tester.state(find.byType(WatchlistPage));
      state.didPopNext();
      await tester.pump();

      verify(mockWatchlistMovieBloc.add(const FetchWatchlistMovies())).called(1);
      verify(mockWatchlistTvBloc.add(const FetchWatchlistTVs())).called(1);
    });
  });

  group('AboutPage', () {
    testWidgets('shows about content', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AboutPage()));
      await tester.pump();

      expect(
        find.textContaining('Ditonton merupakan sebuah aplikasi'),
        findsOneWidget,
      );
    });

    testWidgets('back button pops the page', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AboutPage()));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pump();
    });
  });
}
