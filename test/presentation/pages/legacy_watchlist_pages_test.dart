import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/watchlist_tvs_page.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../dummy_data/dummy_objects_tv.dart';
import 'legacy_watchlist_pages_test.mocks.dart';

@GenerateMocks([WatchlistMovieNotifier, WatchlistTVNotifier])
void main() {
  late MockWatchlistMovieNotifier mockWatchlistMovieNotifier;
  late MockWatchlistTVNotifier mockWatchlistTvNotifier;

  setUp(() {
    mockWatchlistMovieNotifier = MockWatchlistMovieNotifier();
    mockWatchlistTvNotifier = MockWatchlistTVNotifier();
  });

  group('WatchlistMoviesPage', () {
    Widget makeTestable() {
      return ChangeNotifierProvider<WatchlistMovieNotifier>.value(
        value: mockWatchlistMovieNotifier,
        child: MaterialApp(
          home: const WatchlistMoviesPage(),
          navigatorObservers: [routeObserver],
        ),
      );
    }

    testWidgets('shows progress bar when loading', (tester) async {
      when(mockWatchlistMovieNotifier.watchlistState)
          .thenReturn(RequestState.loading);

      await tester.pumpWidget(makeTestable());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows list when loaded with data', (tester) async {
      when(mockWatchlistMovieNotifier.watchlistState)
          .thenReturn(RequestState.loaded);
      when(mockWatchlistMovieNotifier.watchlistMovies)
          .thenReturn([testWatchlistMovie]);

      await tester.pumpWidget(makeTestable());
      await tester.pump();

      expect(find.byType(MovieCard), findsOneWidget);
    });

    testWidgets('shows message when error', (tester) async {
      when(mockWatchlistMovieNotifier.watchlistState)
          .thenReturn(RequestState.error);
      when(mockWatchlistMovieNotifier.message).thenReturn('Error message');

      await tester.pumpWidget(makeTestable());

      expect(find.byKey(const Key('error_message')), findsOneWidget);
    });

    testWidgets('refreshes when returning from another route', (tester) async {
      when(mockWatchlistMovieNotifier.watchlistState)
          .thenReturn(RequestState.loaded);
      when(mockWatchlistMovieNotifier.watchlistMovies).thenReturn([]);

      await tester.pumpWidget(makeTestable());
      await tester.pump();

      final context = tester.element(find.byType(WatchlistMoviesPage));
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const Scaffold()));
      await tester.pumpAndSettle();
      Navigator.of(context).pop();
      await tester.pumpAndSettle();

      verify(mockWatchlistMovieNotifier.fetchWatchlistMovies())
          .called(greaterThanOrEqualTo(1));
    });
  });

  group('WatchlistTVsPage', () {
    Widget makeTestable() {
      return ChangeNotifierProvider<WatchlistTVNotifier>.value(
        value: mockWatchlistTvNotifier,
        child: MaterialApp(
          home: const WatchlistTVsPage(),
          navigatorObservers: [routeObserver],
        ),
      );
    }

    testWidgets('shows progress bar when loading', (tester) async {
      when(mockWatchlistTvNotifier.watchlistState)
          .thenReturn(RequestState.loading);

      await tester.pumpWidget(makeTestable());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows list when loaded with data', (tester) async {
      when(mockWatchlistTvNotifier.watchlistState)
          .thenReturn(RequestState.loaded);
      when(mockWatchlistTvNotifier.watchlistTvs).thenReturn([testWatchlistTv]);

      await tester.pumpWidget(makeTestable());
      await tester.pump();

      expect(find.byType(TVCard), findsOneWidget);
    });

    testWidgets('shows message when error', (tester) async {
      when(mockWatchlistTvNotifier.watchlistState)
          .thenReturn(RequestState.error);
      when(mockWatchlistTvNotifier.message).thenReturn('Error message');

      await tester.pumpWidget(makeTestable());

      expect(find.byKey(const Key('error_message')), findsOneWidget);
    });

    testWidgets('refreshes when returning from another route', (tester) async {
      when(mockWatchlistTvNotifier.watchlistState)
          .thenReturn(RequestState.loaded);
      when(mockWatchlistTvNotifier.watchlistTvs).thenReturn([]);

      await tester.pumpWidget(makeTestable());
      await tester.pump();

      final context = tester.element(find.byType(WatchlistTVsPage));
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const Scaffold()));
      await tester.pumpAndSettle();
      Navigator.of(context).pop();
      await tester.pumpAndSettle();

      verify(mockWatchlistTvNotifier.fetchWatchlistTvs())
          .called(greaterThanOrEqualTo(1));
    });
  });
}
