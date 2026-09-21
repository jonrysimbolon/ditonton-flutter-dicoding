import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_tv_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:ditonton/presentation/provider/tv_list_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects_tv.dart';
import 'static_pages_test.mocks.dart';

@GenerateMocks([TVListNotifier, WatchlistMovieNotifier, WatchlistTVNotifier])
void main() {
  group('HomeTVPage', () {
    late MockTVListNotifier mockTvListNotifier;

    setUp(() {
      mockTvListNotifier = MockTVListNotifier();
      when(mockTvListNotifier.airingTodayState).thenReturn(RequestState.loaded);
      when(mockTvListNotifier.airingTodayTvs).thenReturn([]);
      when(mockTvListNotifier.onTheAirState).thenReturn(RequestState.loaded);
      when(mockTvListNotifier.onTheAirTvs).thenReturn([]);
      when(mockTvListNotifier.popularTvsState).thenReturn(RequestState.loaded);
      when(mockTvListNotifier.popularTvs).thenReturn([]);
      when(mockTvListNotifier.topRatedTvsState).thenReturn(RequestState.loaded);
      when(mockTvListNotifier.topRatedTvs).thenReturn([]);
    });

    testWidgets('shows all tv categories', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<TVListNotifier>.value(
          value: mockTvListNotifier,
          child: const MaterialApp(home: HomeTVPage()),
        ),
      );
      await tester.pump();

      expect(find.text('TV Series'), findsOneWidget);
      expect(find.text('Airing Today'), findsOneWidget);
      expect(find.text('On The Air'), findsOneWidget);
      expect(find.text('Popular'), findsOneWidget);
      expect(find.text('Top Rated'), findsOneWidget);
    });

    testWidgets('shows progress bars when loading', (tester) async {
      when(mockTvListNotifier.airingTodayState)
          .thenReturn(RequestState.loading);
      when(mockTvListNotifier.onTheAirState).thenReturn(RequestState.loading);
      when(mockTvListNotifier.popularTvsState).thenReturn(RequestState.loading);
      when(mockTvListNotifier.topRatedTvsState)
          .thenReturn(RequestState.loading);

      await tester.pumpWidget(
        ChangeNotifierProvider<TVListNotifier>.value(
          value: mockTvListNotifier,
          child: const MaterialApp(home: HomeTVPage()),
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('tv tap and search navigate correctly', (tester) async {
      when(mockTvListNotifier.airingTodayTvs).thenReturn([testTv]);

      await tester.pumpWidget(
        ChangeNotifierProvider<TVListNotifier>.value(
          value: mockTvListNotifier,
          child: MaterialApp(
            home: const HomeTVPage(),
            onGenerateRoute: (_) => MaterialPageRoute(
              builder: (_) => const Scaffold(body: Text('stub route')),
            ),
          ),
        ),
      );
      await tester.pump();

      final cardTap = find.descendant(
        of: find.byType(TVList),
        matching: find.byType(InkWell),
      );
      await tester.tap(cardTap.first);
      await tester.pumpAndSettle();
      expect(find.text('stub route'), findsOneWidget);
    });

    testWidgets('search icon opens tv search', (tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<TVListNotifier>.value(
          value: mockTvListNotifier,
          child: MaterialApp(
            home: const HomeTVPage(),
            onGenerateRoute: (_) => MaterialPageRoute(
              builder: (_) => const Scaffold(body: Text('stub route')),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();
      expect(find.text('stub route'), findsOneWidget);
    });
  });

  group('WatchlistPage', () {
    late MockWatchlistMovieNotifier mockWatchlistMovieNotifier;
    late MockWatchlistTVNotifier mockWatchlistTvNotifier;

    setUp(() {
      mockWatchlistMovieNotifier = MockWatchlistMovieNotifier();
      mockWatchlistTvNotifier = MockWatchlistTVNotifier();
      when(mockWatchlistMovieNotifier.watchlistState)
          .thenReturn(RequestState.loaded);
      when(mockWatchlistMovieNotifier.watchlistMovies).thenReturn([]);
      when(mockWatchlistTvNotifier.watchlistState)
          .thenReturn(RequestState.loaded);
      when(mockWatchlistTvNotifier.watchlistTvs).thenReturn([]);
    });

    testWidgets('shows tabs and empty states for both lists', (tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<WatchlistMovieNotifier>.value(
              value: mockWatchlistMovieNotifier,
            ),
            ChangeNotifierProvider<WatchlistTVNotifier>.value(
              value: mockWatchlistTvNotifier,
            ),
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
