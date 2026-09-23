import 'dart:async';

import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_movie/presentation/bloc/movie_list_bloc.dart';
import 'package:ditonton_movie/presentation/bloc/popular_movies_bloc.dart';
import 'package:ditonton_movie/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:ditonton_movie/presentation/pages/popular_movies_page.dart';
import 'package:ditonton_movie/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton_movie/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'list_pages_nonempty_test.mocks.dart';

@GenerateMocks([PopularMoviesBloc, TopRatedMoviesBloc])
void main() {
  group('Movie list pages with data', () {
    testWidgets('PopularMoviesPage shows cards', (tester) async {
      final mockBloc = MockPopularMoviesBloc();
      final streamController = StreamController<PopularMoviesState>.broadcast();
      when(mockBloc.stream).thenAnswer((_) => streamController.stream);
      when(mockBloc.state).thenReturn(
        const PopularMoviesState(
          state: RequestState.loaded,
          movies: [testWatchlistMovie],
        ),
      );

      await tester.pumpWidget(
        BlocProvider<PopularMoviesBloc>.value(
          value: mockBloc,
          child: const MaterialApp(home: PopularMoviesPage()),
        ),
      );
      await tester.pump();

      expect(find.byType(MovieCard), findsOneWidget);
      await streamController.close();
    });

    testWidgets('popular events support equality', (tester) async {
      expect(FetchPopularMovies(), FetchPopularMovies());
      expect(FetchPopularMovies().props, isEmpty);
      expect(FetchNowPlayingMovies().props, isEmpty);
      expect(TopRatedMoviesEvent(), TopRatedMoviesEvent());
    });

    testWidgets('TopRatedMoviesPage shows cards', (tester) async {
      final mockBloc = MockTopRatedMoviesBloc();
      final streamController =
          StreamController<TopRatedMoviesState>.broadcast();
      when(mockBloc.stream).thenAnswer((_) => streamController.stream);
      when(mockBloc.state).thenReturn(
        const TopRatedMoviesState(
          state: RequestState.loaded,
          movies: [testWatchlistMovie],
        ),
      );

      await tester.pumpWidget(
        BlocProvider<TopRatedMoviesBloc>.value(
          value: mockBloc,
          child: const MaterialApp(home: TopRatedMoviesPage()),
        ),
      );
      await tester.pump();

      expect(find.byType(MovieCard), findsOneWidget);
      await streamController.close();
    });
  });
}
