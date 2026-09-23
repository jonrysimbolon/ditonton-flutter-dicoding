import 'dart:async';

import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_tv/presentation/bloc/airing_today_tvs_bloc.dart';
import 'package:ditonton_tv/presentation/bloc/tv_list_bloc.dart';
import 'package:ditonton_tv/presentation/bloc/on_the_air_tvs_bloc.dart';
import 'package:ditonton_tv/presentation/bloc/popular_tvs_bloc.dart';
import 'package:ditonton_tv/presentation/bloc/top_rated_tvs_bloc.dart';
import 'package:ditonton_tv/presentation/pages/airing_today_tvs_page.dart';
import 'package:ditonton_tv/presentation/pages/on_the_air_tvs_page.dart';
import 'package:ditonton_tv/presentation/pages/popular_tvs_page.dart';
import 'package:ditonton_tv/presentation/pages/top_rated_tvs_page.dart';
import 'package:ditonton_tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects_tv.dart';
import 'list_pages_nonempty_test.mocks.dart';

@GenerateMocks([
  PopularTVsBloc,
  TopRatedTVsBloc,
  AiringTodayTVsBloc,
  OnTheAirTVsBloc,
])
void main() {
  group('TV list pages with data', () {
    testWidgets('PopularTVsPage shows cards', (tester) async {
      final mockBloc = MockPopularTVsBloc();
      final streamController = StreamController<PopularTVsState>.broadcast();
      when(mockBloc.stream).thenAnswer((_) => streamController.stream);
      when(mockBloc.state).thenReturn(
        const PopularTVsState(
          state: RequestState.loaded,
          tvs: [testWatchlistTv],
        ),
      );

      await tester.pumpWidget(
        BlocProvider<PopularTVsBloc>.value(
          value: mockBloc,
          child: const MaterialApp(home: PopularTVsPage()),
        ),
      );
      await tester.pump();

      expect(find.byType(TVCard), findsOneWidget);
      await streamController.close();
    });

    testWidgets('popular events support equality', (tester) async {
      expect(FetchPopularTVs(), FetchPopularTVs());
      expect(FetchPopularTVs().props, isEmpty);
      expect(FetchAiringTodayTvsList().props, isEmpty);
      expect(AiringTodayTVsEvent(), AiringTodayTVsEvent());
      expect(OnTheAirTVsEvent(), OnTheAirTVsEvent());
      expect(TopRatedTVsEvent(), TopRatedTVsEvent());
    });

    testWidgets('TopRatedTVsPage shows cards', (tester) async {
      final mockBloc = MockTopRatedTVsBloc();
      final streamController = StreamController<TopRatedTVsState>.broadcast();
      when(mockBloc.stream).thenAnswer((_) => streamController.stream);
      when(mockBloc.state).thenReturn(
        const TopRatedTVsState(
          state: RequestState.loaded,
          tvs: [testWatchlistTv],
        ),
      );

      await tester.pumpWidget(
        BlocProvider<TopRatedTVsBloc>.value(
          value: mockBloc,
          child: const MaterialApp(home: TopRatedTVsPage()),
        ),
      );
      await tester.pump();

      expect(find.byType(TVCard), findsOneWidget);
      await streamController.close();
    });

    testWidgets('AiringTodayTVsPage shows cards', (tester) async {
      final mockBloc = MockAiringTodayTVsBloc();
      final streamController =
          StreamController<AiringTodayTVsState>.broadcast();
      when(mockBloc.stream).thenAnswer((_) => streamController.stream);
      when(mockBloc.state).thenReturn(
        const AiringTodayTVsState(
          state: RequestState.loaded,
          tvs: [testWatchlistTv],
        ),
      );

      await tester.pumpWidget(
        BlocProvider<AiringTodayTVsBloc>.value(
          value: mockBloc,
          child: const MaterialApp(home: AiringTodayTVsPage()),
        ),
      );
      await tester.pump();

      expect(find.byType(TVCard), findsOneWidget);
      await streamController.close();
    });

    testWidgets('OnTheAirTVsPage shows cards', (tester) async {
      final mockBloc = MockOnTheAirTVsBloc();
      final streamController = StreamController<OnTheAirTVsState>.broadcast();
      when(mockBloc.stream).thenAnswer((_) => streamController.stream);
      when(mockBloc.state).thenReturn(
        const OnTheAirTVsState(
          state: RequestState.loaded,
          tvs: [testWatchlistTv],
        ),
      );

      await tester.pumpWidget(
        BlocProvider<OnTheAirTVsBloc>.value(
          value: mockBloc,
          child: const MaterialApp(home: OnTheAirTVsPage()),
        ),
      );
      await tester.pump();

      expect(find.byType(TVCard), findsOneWidget);
      await streamController.close();
    });
  });
}
