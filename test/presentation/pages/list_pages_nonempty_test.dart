import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/airing_today_tvs_page.dart';
import 'package:ditonton/presentation/pages/on_the_air_tvs_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tvs_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tvs_page.dart';
import 'package:ditonton/presentation/provider/airing_today_tvs_notifier.dart';
import 'package:ditonton/presentation/provider/on_the_air_tvs_notifier.dart';
import 'package:ditonton/presentation/provider/popular_movies_notifier.dart';
import 'package:ditonton/presentation/provider/popular_tvs_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_movies_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_tvs_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../dummy_data/dummy_objects_tv.dart';
import 'list_pages_nonempty_test.mocks.dart';

@GenerateMocks([
  PopularMoviesNotifier,
  TopRatedMoviesNotifier,
  PopularTVsNotifier,
  TopRatedTVsNotifier,
  AiringTodayTVsNotifier,
  OnTheAirTVsNotifier,
])
void main() {
  group('Movie list pages with data', () {
    testWidgets('PopularMoviesPage shows cards', (tester) async {
      final mockNotifier = MockPopularMoviesNotifier();
      when(mockNotifier.state).thenReturn(RequestState.loaded);
      when(mockNotifier.movies).thenReturn([testWatchlistMovie]);

      await tester.pumpWidget(
        ChangeNotifierProvider<PopularMoviesNotifier>.value(
          value: mockNotifier,
          child: const MaterialApp(home: PopularMoviesPage()),
        ),
      );
      await tester.pump();

      expect(find.byType(MovieCard), findsOneWidget);
    });

    testWidgets('TopRatedMoviesPage shows cards', (tester) async {
      final mockNotifier = MockTopRatedMoviesNotifier();
      when(mockNotifier.state).thenReturn(RequestState.loaded);
      when(mockNotifier.movies).thenReturn([testWatchlistMovie]);

      await tester.pumpWidget(
        ChangeNotifierProvider<TopRatedMoviesNotifier>.value(
          value: mockNotifier,
          child: const MaterialApp(home: TopRatedMoviesPage()),
        ),
      );
      await tester.pump();

      expect(find.byType(MovieCard), findsOneWidget);
    });
  });

  group('TV list pages with data', () {
    testWidgets('PopularTVsPage shows cards', (tester) async {
      final mockNotifier = MockPopularTVsNotifier();
      when(mockNotifier.state).thenReturn(RequestState.loaded);
      when(mockNotifier.tvs).thenReturn([testWatchlistTv]);

      await tester.pumpWidget(
        ChangeNotifierProvider<PopularTVsNotifier>.value(
          value: mockNotifier,
          child: const MaterialApp(home: PopularTVsPage()),
        ),
      );
      await tester.pump();

      expect(find.byType(TVCard), findsOneWidget);
    });

    testWidgets('TopRatedTVsPage shows cards', (tester) async {
      final mockNotifier = MockTopRatedTVsNotifier();
      when(mockNotifier.state).thenReturn(RequestState.loaded);
      when(mockNotifier.tvs).thenReturn([testWatchlistTv]);

      await tester.pumpWidget(
        ChangeNotifierProvider<TopRatedTVsNotifier>.value(
          value: mockNotifier,
          child: const MaterialApp(home: TopRatedTVsPage()),
        ),
      );
      await tester.pump();

      expect(find.byType(TVCard), findsOneWidget);
    });

    testWidgets('AiringTodayTVsPage shows cards', (tester) async {
      final mockNotifier = MockAiringTodayTVsNotifier();
      when(mockNotifier.state).thenReturn(RequestState.loaded);
      when(mockNotifier.tvs).thenReturn([testWatchlistTv]);

      await tester.pumpWidget(
        ChangeNotifierProvider<AiringTodayTVsNotifier>.value(
          value: mockNotifier,
          child: const MaterialApp(home: AiringTodayTVsPage()),
        ),
      );
      await tester.pump();

      expect(find.byType(TVCard), findsOneWidget);
    });

    testWidgets('OnTheAirTVsPage shows cards', (tester) async {
      final mockNotifier = MockOnTheAirTVsNotifier();
      when(mockNotifier.state).thenReturn(RequestState.loaded);
      when(mockNotifier.tvs).thenReturn([testWatchlistTv]);

      await tester.pumpWidget(
        ChangeNotifierProvider<OnTheAirTVsNotifier>.value(
          value: mockNotifier,
          child: const MaterialApp(home: OnTheAirTVsPage()),
        ),
      );
      await tester.pump();

      expect(find.byType(TVCard), findsOneWidget);
    });
  });
}
