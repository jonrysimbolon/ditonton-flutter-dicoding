import 'package:ditonton_core/common/constants.dart';
import 'package:ditonton_core/common/ssl_pinning.dart';
import 'package:ditonton_core/common/utils.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton_tv/presentation/pages/airing_today_tvs_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
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
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';

import 'dart:io' show HttpOverrides, Platform;
import 'dart:ui' show PlatformDispatcher;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.environment['FLUTTER_TEST'] != 'true') {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseAnalytics.instance.logEvent(name: 'app_open');
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kReleaseMode);
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }
  HttpOverrides.global = SslPinningHttpOverrides();
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.locator<MovieListBloc>()),
        BlocProvider(create: (_) => di.locator<MovieDetailBloc>()),
        BlocProvider(create: (_) => di.locator<MovieSearchBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<PopularMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistMovieBloc>()),
        BlocProvider(create: (_) => di.locator<TVListBloc>()),
        BlocProvider(create: (_) => di.locator<TVDetailBloc>()),
        BlocProvider(create: (_) => di.locator<TVSearchBloc>()),
        BlocProvider(create: (_) => di.locator<TopRatedTVsBloc>()),
        BlocProvider(create: (_) => di.locator<PopularTVsBloc>()),
        BlocProvider(create: (_) => di.locator<AiringTodayTVsBloc>()),
        BlocProvider(create: (_) => di.locator<OnTheAirTVsBloc>()),
        BlocProvider(create: (_) => di.locator<WatchlistTVBloc>()),
      ],
      child: MaterialApp(
        title: 'Ditonton',
        theme: ThemeData.dark().copyWith(
          colorScheme: colorScheme,
          primaryColor: richBlack,
          scaffoldBackgroundColor: richBlack,
          textTheme: textTheme,
          drawerTheme: drawerTheme,
        ),
        home: const HomeMoviePage(),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => const HomeMoviePage());
            case HomeTVPage.routeName:
              return MaterialPageRoute(builder: (_) => const HomeTVPage());
            case PopularMoviesPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const PopularMoviesPage(),
              );
            case TopRatedMoviesPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const TopRatedMoviesPage(),
              );
            case MovieDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case SearchPage.routeName:
              return CupertinoPageRoute(builder: (_) => const SearchPage());
            case WatchlistMoviesPage.routeName:
              return MaterialPageRoute(
                builder: (_) => const WatchlistMoviesPage(),
              );
            case WatchlistPage.routeName:
              return MaterialPageRoute(builder: (_) => const WatchlistPage());
            case PopularTVsPage.routeName:
              return CupertinoPageRoute(builder: (_) => const PopularTVsPage());
            case TopRatedTVsPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const TopRatedTVsPage(),
              );
            case AiringTodayTVsPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const AiringTodayTVsPage(),
              );
            case OnTheAirTVsPage.routeName:
              return CupertinoPageRoute(
                builder: (_) => const OnTheAirTVsPage(),
              );
            case TVDetailPage.routeName:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TVDetailPage(id: id),
                settings: settings,
              );
            case TVDetailPage.routeNameAlias:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TVDetailPage(id: id),
                settings: settings,
              );
            case TVSeasonPage.routeName:
              final args = settings.arguments as TVSeasonArguments;
              return MaterialPageRoute(
                builder: (_) =>
                    TVSeasonPage(id: args.id, seasonNumber: args.seasonNumber),
                settings: settings,
              );
            case SearchTVPage.routeName:
              return CupertinoPageRoute(builder: (_) => const SearchTVPage());
            case WatchlistTVsPage.routeName:
              return MaterialPageRoute(
                builder: (_) => const WatchlistTVsPage(),
              );
            case AboutPage.routeName:
              return MaterialPageRoute(builder: (_) => const AboutPage());
            default:
              return MaterialPageRoute(
                builder: (_) {
                  return const Scaffold(
                    body: Center(child: Text('Page not found :(')),
                  );
                },
              );
          }
        },
      ),
    );
  }
}
