import 'dart:async';

import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_core/common/utils.dart';
import 'package:ditonton_movie/presentation/bloc/movie_list_bloc.dart';
import 'package:ditonton_tv/presentation/bloc/tv_list_bloc.dart';
import 'package:ditonton_movie/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:ditonton_tv/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton_movie/presentation/widgets/movie_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'home_movie_page_test.mocks.dart';

@GenerateMocks([MovieListBloc, TVListBloc, WatchlistMovieBloc, WatchlistTVBloc])
void main() {
  late MockMovieListBloc mockMovieListBloc;
  late MockTVListBloc mockTvListBloc;
  late MockWatchlistMovieBloc mockWatchlistMovieBloc;
  late MockWatchlistTVBloc mockWatchlistTvBloc;
  late StreamController<MovieListState> movieListStreamController;
  late StreamController<TVListState> tvListStreamController;
  late StreamController<WatchlistMovieState> watchlistMovieStreamController;
  late StreamController<WatchlistTVState> watchlistTvStreamController;

  setUp(() {
    mockMovieListBloc = MockMovieListBloc();
    mockTvListBloc = MockTVListBloc();
    mockWatchlistMovieBloc = MockWatchlistMovieBloc();
    mockWatchlistTvBloc = MockWatchlistTVBloc();

    movieListStreamController = StreamController<MovieListState>.broadcast();
    tvListStreamController = StreamController<TVListState>.broadcast();
    watchlistMovieStreamController =
        StreamController<WatchlistMovieState>.broadcast();
    watchlistTvStreamController =
        StreamController<WatchlistTVState>.broadcast();

    when(mockMovieListBloc.stream)
        .thenAnswer((_) => movieListStreamController.stream);
    when(mockTvListBloc.stream)
        .thenAnswer((_) => tvListStreamController.stream);
    when(mockWatchlistMovieBloc.stream)
        .thenAnswer((_) => watchlistMovieStreamController.stream);
    when(mockWatchlistTvBloc.stream)
        .thenAnswer((_) => watchlistTvStreamController.stream);

    when(mockMovieListBloc.state).thenReturn(
      const MovieListState(
        nowPlayingState: RequestState.loaded,
        popularMoviesState: RequestState.loaded,
        topRatedMoviesState: RequestState.loaded,
      ),
    );
    when(mockTvListBloc.state).thenReturn(
      const TVListState(
        airingTodayState: RequestState.loaded,
        onTheAirState: RequestState.loaded,
        popularTvsState: RequestState.loaded,
        topRatedTvsState: RequestState.loaded,
      ),
    );
    when(mockWatchlistMovieBloc.state).thenReturn(
      const WatchlistMovieState(watchlistState: RequestState.loaded),
    );
    when(
      mockWatchlistTvBloc.state,
    ).thenReturn(const WatchlistTVState(watchlistState: RequestState.loaded));
  });

  tearDown(() {
    movieListStreamController.close();
    tvListStreamController.close();
    watchlistMovieStreamController.close();
    watchlistTvStreamController.close();
  });

  Widget makeTestable() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MovieListBloc>.value(value: mockMovieListBloc),
        BlocProvider<TVListBloc>.value(value: mockTvListBloc),
        BlocProvider<WatchlistMovieBloc>.value(value: mockWatchlistMovieBloc),
        BlocProvider<WatchlistTVBloc>.value(value: mockWatchlistTvBloc),
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

  testWidgets('initState fetches movies', (tester) async {
    await tester.pumpWidget(makeTestable());
    await tester.pump();

    verify(mockMovieListBloc.add(const FetchNowPlayingMovies())).called(1);
    verify(mockMovieListBloc.add(const FetchPopularMoviesList())).called(1);
    verify(mockMovieListBloc.add(const FetchTopRatedMoviesList())).called(1);
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
    verify(mockTvListBloc.add(const FetchAiringTodayTvsList())).called(1);
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
    verify(mockWatchlistMovieBloc.add(const FetchWatchlistMovies()))
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
    when(mockMovieListBloc.state).thenReturn(
      const MovieListState(
        nowPlayingState: RequestState.loading,
        popularMoviesState: RequestState.loading,
        topRatedMoviesState: RequestState.loading,
      ),
    );

    await tester.pumpWidget(makeTestable());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('movie tap navigates to detail', (tester) async {
    when(mockMovieListBloc.state).thenReturn(
      const MovieListState(
        nowPlayingState: RequestState.loaded,
        nowPlayingMovies: [testMovie],
        popularMoviesState: RequestState.loaded,
        topRatedMoviesState: RequestState.loaded,
      ),
    );

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

    verify(mockWatchlistMovieBloc.add(const FetchWatchlistMovies()))
        .called(greaterThanOrEqualTo(1));
    verify(mockWatchlistTvBloc.add(const FetchWatchlistTVs()))
        .called(greaterThanOrEqualTo(1));
  });
}
