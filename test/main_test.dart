import 'package:ditonton/main.dart';
import 'package:ditonton_tv/presentation/bloc/airing_today_tvs_bloc.dart';
import 'package:ditonton_movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:ditonton_movie/presentation/bloc/movie_list_bloc.dart';
import 'package:ditonton_movie/presentation/bloc/movie_search_bloc.dart';
import 'package:ditonton_tv/presentation/bloc/on_the_air_tvs_bloc.dart';
import 'package:ditonton_movie/presentation/bloc/popular_movies_bloc.dart';
import 'package:ditonton_tv/presentation/bloc/popular_tvs_bloc.dart';
import 'package:ditonton_movie/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:ditonton_tv/presentation/bloc/top_rated_tvs_bloc.dart';
import 'package:ditonton_tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:ditonton_tv/presentation/bloc/tv_list_bloc.dart';
import 'package:ditonton_tv/presentation/bloc/tv_search_bloc.dart';
import 'package:ditonton_movie/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:ditonton_tv/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton_tv/presentation/pages/airing_today_tvs_page.dart';
import 'package:ditonton_tv/presentation/pages/home_tv_page.dart';
import 'package:ditonton_movie/presentation/pages/movie_detail_page.dart';
import 'package:ditonton_tv/presentation/pages/on_the_air_tvs_page.dart';
import 'package:ditonton_movie/presentation/pages/popular_movies_page.dart';
import 'package:ditonton_tv/presentation/pages/popular_tvs_page.dart';
import 'package:ditonton_movie/presentation/pages/search_page.dart';
import 'package:ditonton_tv/presentation/pages/search_tv_page.dart';
import 'package:ditonton_movie/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton_tv/presentation/pages/top_rated_tvs_page.dart';
import 'package:ditonton_tv/presentation/pages/tv_detail_page.dart';
import 'package:ditonton_tv/presentation/pages/tv_season_arguments.dart';
import 'package:ditonton_tv/presentation/pages/tv_season_page.dart';
import 'package:ditonton_movie/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:ditonton_tv/presentation/pages/watchlist_tvs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
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
    context.read<MovieListBloc>();
    context.read<MovieDetailBloc>();
    context.read<MovieSearchBloc>();
    context.read<TopRatedMoviesBloc>();
    context.read<PopularMoviesBloc>();
    context.read<WatchlistMovieBloc>();
    context.read<TVListBloc>();
    context.read<TVDetailBloc>();
    context.read<TVSearchBloc>();
    context.read<TopRatedTVsBloc>();
    context.read<PopularTVsBloc>();
    context.read<AiringTodayTVsBloc>();
    context.read<OnTheAirTVsBloc>();
    context.read<WatchlistTVBloc>();

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
