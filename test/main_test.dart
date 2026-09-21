import 'package:ditonton/main.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/airing_today_tvs_page.dart';
import 'package:ditonton/presentation/pages/home_tv_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/on_the_air_tvs_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tvs_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/search_tv_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tvs_page.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/pages/tv_season_arguments.dart';
import 'package:ditonton/presentation/pages/tv_season_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:ditonton/presentation/pages/watchlist_tvs_page.dart';
import 'package:ditonton/presentation/provider/airing_today_tvs_notifier.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/presentation/provider/on_the_air_tvs_notifier.dart';
import 'package:ditonton/presentation/provider/popular_movies_notifier.dart';
import 'package:ditonton/presentation/provider/popular_tvs_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_movies_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_tvs_notifier.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:ditonton/presentation/provider/tv_list_notifier.dart';
import 'package:ditonton/presentation/provider/tv_search_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:ditonton/injection.dart' as di;

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    di.init();
  });

  testWidgets('app starts on movies and drawer reaches tv section', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Ditonton'), findsOneWidget);
    expect(find.text('Now Playing'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();
    expect(find.byType(Drawer), findsOneWidget);

    await tester.tap(find.text('TV Series'));
    await tester.pumpAndSettle();

    expect(find.byType(Drawer), findsNothing);
    expect(find.text('Airing Today'), findsOneWidget);
  });

  testWidgets('drawer reaches watchlist tabs and about section', (
    tester,
  ) async {
    Future<void> settleFrames() async {
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 200));
      }
    }

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu));
    await settleFrames();
    await tester.tap(find.text('Watchlist'));
    await settleFrames();

    expect(find.text('Watchlist'), findsWidgets);
    expect(find.byType(TabBar), findsOneWidget);

    await tester.tap(find.byIcon(Icons.menu));
    await settleFrames();
    await tester.tap(find.text('About'));
    await settleFrames();

    expect(
      find.textContaining('Ditonton merupakan sebuah aplikasi'),
      findsOneWidget,
    );
  });

  testWidgets('resolves all registered dependencies', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(Scaffold));
    Provider.of<MovieListNotifier>(context, listen: false);
    Provider.of<MovieDetailNotifier>(context, listen: false);
    Provider.of<MovieSearchNotifier>(context, listen: false);
    Provider.of<TopRatedMoviesNotifier>(context, listen: false);
    Provider.of<PopularMoviesNotifier>(context, listen: false);
    Provider.of<WatchlistMovieNotifier>(context, listen: false);
    Provider.of<TVListNotifier>(context, listen: false);
    Provider.of<TVDetailNotifier>(context, listen: false);
    Provider.of<TVSearchNotifier>(context, listen: false);
    Provider.of<TopRatedTVsNotifier>(context, listen: false);
    Provider.of<PopularTVsNotifier>(context, listen: false);
    Provider.of<AiringTodayTVsNotifier>(context, listen: false);
    Provider.of<OnTheAirTVsNotifier>(context, listen: false);
    Provider.of<WatchlistTVNotifier>(context, listen: false);

    expect(find.text('Ditonton'), findsOneWidget);
  });

  testWidgets('generates every registered route', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(Scaffold));
    Future<void> visit(String name, {Object? arguments}) async {
      Navigator.of(context).pushNamed(name, arguments: arguments);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 400)),
      );
      await tester.pump(const Duration(milliseconds: 200));
      Navigator.of(context).pop();
      await tester.pump();
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 400)),
      );
      await tester.pump(const Duration(milliseconds: 200));
    }

    await visit('/home');
    await visit(HomeTVPage.routeName);
    await visit(PopularMoviesPage.routeName);
    await visit(TopRatedMoviesPage.routeName);
    await visit(MovieDetailPage.routeName, arguments: 1);
    await visit(SearchPage.routeName);
    await visit(WatchlistMoviesPage.routeName);
    await visit(WatchlistPage.routeName);
    await visit(PopularTVsPage.routeName);
    await visit(TopRatedTVsPage.routeName);
    await visit(AiringTodayTVsPage.routeName);
    await visit(OnTheAirTVsPage.routeName);
    await visit(TVDetailPage.routeName, arguments: 1);
    await visit(TVDetailPage.routeNameAlias, arguments: 1);
    await visit(
      TVSeasonPage.routeName,
      arguments: const TVSeasonArguments(id: 1, seasonNumber: 1),
    );
    await visit(SearchTVPage.routeName);
    await visit(WatchlistTVsPage.routeName);
    await visit(AboutPage.routeName);
    await visit('/unknown-route');

    expect(find.text('Ditonton'), findsOneWidget);
  });
}
