import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/presentation/provider/tv_list_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import 'home_movie_page_test.mocks.dart';

@GenerateMocks([
  MovieListNotifier,
  TVListNotifier,
  WatchlistMovieNotifier,
  WatchlistTVNotifier,
])
void main() {
  late MockMovieListNotifier mockMovieListNotifier;
  late MockTVListNotifier mockTvListNotifier;
  late MockWatchlistMovieNotifier mockWatchlistMovieNotifier;
  late MockWatchlistTVNotifier mockWatchlistTvNotifier;

  setUp(() {
    mockMovieListNotifier = MockMovieListNotifier();
    mockTvListNotifier = MockTVListNotifier();
    mockWatchlistMovieNotifier = MockWatchlistMovieNotifier();
    mockWatchlistTvNotifier = MockWatchlistTVNotifier();

    when(mockMovieListNotifier.nowPlayingState).thenReturn(RequestState.loaded);
    when(mockMovieListNotifier.nowPlayingMovies).thenReturn([]);
    when(mockMovieListNotifier.popularMoviesState)
        .thenReturn(RequestState.loaded);
    when(mockMovieListNotifier.popularMovies).thenReturn([]);
    when(mockMovieListNotifier.topRatedMoviesState)
        .thenReturn(RequestState.loaded);
    when(mockMovieListNotifier.topRatedMovies).thenReturn([]);

    when(mockTvListNotifier.airingTodayState).thenReturn(RequestState.loaded);
    when(mockTvListNotifier.airingTodayTvs).thenReturn([]);
    when(mockTvListNotifier.onTheAirState).thenReturn(RequestState.loaded);
    when(mockTvListNotifier.onTheAirTvs).thenReturn([]);
    when(mockTvListNotifier.popularTvsState).thenReturn(RequestState.loaded);
    when(mockTvListNotifier.popularTvs).thenReturn([]);
    when(mockTvListNotifier.topRatedTvsState).thenReturn(RequestState.loaded);
    when(mockTvListNotifier.topRatedTvs).thenReturn([]);

    when(mockWatchlistMovieNotifier.watchlistState)
        .thenReturn(RequestState.loaded);
    when(mockWatchlistMovieNotifier.watchlistMovies).thenReturn([]);
    when(mockWatchlistTvNotifier.watchlistState)
        .thenReturn(RequestState.loaded);
    when(mockWatchlistTvNotifier.watchlistTvs).thenReturn([]);
  });

  Widget makeTestable() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MovieListNotifier>.value(
          value: mockMovieListNotifier,
        ),
        ChangeNotifierProvider<TVListNotifier>.value(value: mockTvListNotifier),
        ChangeNotifierProvider<WatchlistMovieNotifier>.value(
          value: mockWatchlistMovieNotifier,
        ),
        ChangeNotifierProvider<WatchlistTVNotifier>.value(
          value: mockWatchlistTvNotifier,
        ),
      ],
      child: MaterialApp(
        home: const HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (_) => MaterialPageRoute(
          builder: (_) => const Scaffold(body: Text('stub route')),
        ),
      ),
    );
  }

  Future<void> openDrawer(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    expect(find.byType(Drawer), findsOneWidget);
  }

  testWidgets('shows movies section initially', (tester) async {
    await tester.pumpWidget(makeTestable());
    await tester.pump();

    expect(find.text('Ditonton'), findsOneWidget);
    expect(find.text('Now Playing'), findsOneWidget);
  });

  testWidgets('drawer tap TV Series shows tv content on the same page', (
    tester,
  ) async {
    await tester.pumpWidget(makeTestable());
    await tester.pump();
    await openDrawer(tester);

    await tester.tap(find.text('TV Series'));
    await tester.pumpAndSettle();

    expect(find.byType(Drawer), findsNothing);
    expect(find.text('TV Series'), findsWidgets);
    expect(find.text('Airing Today'), findsOneWidget);
    expect(find.text('Top Rated'), findsOneWidget);
    verify(mockTvListNotifier.fetchAiringTodayTvs()).called(1);
  });

  testWidgets('drawer tap Watchlist shows tabs and empty states', (
    tester,
  ) async {
    await tester.pumpWidget(makeTestable());
    await tester.pump();
    await openDrawer(tester);

    await tester.tap(find.text('Watchlist'));
    await tester.pumpAndSettle();

    expect(find.byType(Drawer), findsNothing);
    expect(find.text('Movies'), findsWidgets);
    expect(find.byKey(const Key('empty_watchlist_movies')), findsOneWidget);
    verify(mockWatchlistMovieNotifier.fetchWatchlistMovies())
        .called(greaterThanOrEqualTo(1));
  });

  testWidgets('drawer tap About shows about content on the same page', (
    tester,
  ) async {
    await tester.pumpWidget(makeTestable());
    await tester.pump();
    await openDrawer(tester);

    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();

    expect(find.byType(Drawer), findsNothing);
    expect(find.text('About'), findsWidgets);
    expect(
      find.textContaining('Ditonton merupakan sebuah aplikasi'),
      findsOneWidget,
    );
  });

  testWidgets('drawer tap Movies returns to movies section', (tester) async {
    await tester.pumpWidget(makeTestable());
    await tester.pump();
    await openDrawer(tester);

    await tester.tap(find.text('TV Series'));
    await tester.pumpAndSettle();
    expect(find.text('Airing Today'), findsOneWidget);

    await openDrawer(tester);
    await tester.tap(find.text('Movies').first);
    await tester.pumpAndSettle();
    expect(find.text('Now Playing'), findsOneWidget);
  });

  testWidgets('shows progress bars when movie lists are loading', (
    tester,
  ) async {
    when(mockMovieListNotifier.nowPlayingState)
        .thenReturn(RequestState.loading);
    when(mockMovieListNotifier.popularMoviesState)
        .thenReturn(RequestState.loading);
    when(mockMovieListNotifier.topRatedMoviesState)
        .thenReturn(RequestState.loading);

    await tester.pumpWidget(makeTestable());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('movie tap navigates to detail', (tester) async {
    when(mockMovieListNotifier.nowPlayingMovies).thenReturn([testMovie]);

    await tester.pumpWidget(makeTestable());
    await tester.pump();

    final cardTap = find.descendant(
      of: find.byType(MovieList),
      matching: find.byType(InkWell),
    );
    await tester.tap(cardTap.first);
    await tester.pumpAndSettle();

    expect(find.text('stub route'), findsOneWidget);
  });

  testWidgets('search icon opens movie search', (tester) async {
    await tester.pumpWidget(makeTestable());
    await tester.pump();

    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    expect(find.text('stub route'), findsOneWidget);
  });

  testWidgets('see more opens popular movies', (tester) async {
    await tester.pumpWidget(makeTestable());
    await tester.pump();

    await tester.tap(find.text('See More').first);
    await tester.pumpAndSettle();

    expect(find.text('stub route'), findsOneWidget);
  });

  testWidgets('refreshes watchlists when returning from another route', (
    tester,
  ) async {
    await tester.pumpWidget(makeTestable());
    await tester.pump();

    final context = tester.element(find.byType(HomeMoviePage));
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const Scaffold()));
    await tester.pumpAndSettle();
    Navigator.of(context).pop();
    await tester.pumpAndSettle();

    verify(mockWatchlistMovieNotifier.fetchWatchlistMovies())
        .called(greaterThanOrEqualTo(1));
    verify(mockWatchlistTvNotifier.fetchWatchlistTvs())
        .called(greaterThanOrEqualTo(1));
  });
}
