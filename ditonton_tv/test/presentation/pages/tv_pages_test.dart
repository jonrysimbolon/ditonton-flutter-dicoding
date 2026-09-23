import 'dart:async';

import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_tv/presentation/bloc/airing_today_tvs_bloc.dart';
import 'package:ditonton_tv/presentation/bloc/on_the_air_tvs_bloc.dart';
import 'package:ditonton_tv/presentation/bloc/popular_tvs_bloc.dart';
import 'package:ditonton_tv/presentation/bloc/top_rated_tvs_bloc.dart';
import 'package:ditonton_tv/presentation/pages/airing_today_tvs_page.dart';
import 'package:ditonton_tv/presentation/pages/on_the_air_tvs_page.dart';
import 'package:ditonton_tv/presentation/pages/popular_tvs_page.dart';
import 'package:ditonton_tv/presentation/pages/top_rated_tvs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_pages_test.mocks.dart';

@GenerateMocks([
  PopularTVsBloc,
  TopRatedTVsBloc,
  AiringTodayTVsBloc,
  OnTheAirTVsBloc,
])
void main() {
  group('PopularTVsPage', () {
    late MockPopularTVsBloc mockBloc;
    late StreamController<PopularTVsState> streamController;

    setUp(() {
      mockBloc = MockPopularTVsBloc();
      streamController = StreamController<PopularTVsState>.broadcast();
      when(mockBloc.stream).thenAnswer((_) => streamController.stream);
    });

    tearDown(() {
      streamController.close();
    });

    Widget makeTestable(Widget body) {
      return BlocProvider<PopularTVsBloc>.value(
        value: mockBloc,
        child: MaterialApp(home: body),
      );
    }

    testWidgets('should display progress bar when loading', (
      WidgetTester tester,
    ) async {
      when(mockBloc.state)
          .thenReturn(const PopularTVsState(state: RequestState.loading));
      await tester.pumpWidget(makeTestable(const PopularTVsPage()));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display ListView when loaded', (
      WidgetTester tester,
    ) async {
      when(
        mockBloc.state,
      ).thenReturn(const PopularTVsState(state: RequestState.loaded, tvs: []));
      await tester.pumpWidget(makeTestable(const PopularTVsPage()));
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should display error message when Error', (
      WidgetTester tester,
    ) async {
      when(mockBloc.state).thenReturn(
        const PopularTVsState(
          state: RequestState.error,
          message: 'Error message',
        ),
      );
      await tester.pumpWidget(makeTestable(const PopularTVsPage()));
      expect(find.byKey(const Key('error_message')), findsOneWidget);
    });
  });

  group('TopRatedTVsPage', () {
    late MockTopRatedTVsBloc mockBloc;
    late StreamController<TopRatedTVsState> streamController;

    setUp(() {
      mockBloc = MockTopRatedTVsBloc();
      streamController = StreamController<TopRatedTVsState>.broadcast();
      when(mockBloc.stream).thenAnswer((_) => streamController.stream);
    });

    tearDown(() {
      streamController.close();
    });

    Widget makeTestable(Widget body) {
      return BlocProvider<TopRatedTVsBloc>.value(
        value: mockBloc,
        child: MaterialApp(home: body),
      );
    }

    testWidgets('should display progress bar when loading', (
      WidgetTester tester,
    ) async {
      when(mockBloc.state)
          .thenReturn(const TopRatedTVsState(state: RequestState.loading));
      await tester.pumpWidget(makeTestable(const TopRatedTVsPage()));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display ListView when loaded', (
      WidgetTester tester,
    ) async {
      when(
        mockBloc.state,
      ).thenReturn(const TopRatedTVsState(state: RequestState.loaded, tvs: []));
      await tester.pumpWidget(makeTestable(const TopRatedTVsPage()));
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should display error message when Error', (
      WidgetTester tester,
    ) async {
      when(mockBloc.state).thenReturn(
        const TopRatedTVsState(
          state: RequestState.error,
          message: 'Error message',
        ),
      );
      await tester.pumpWidget(makeTestable(const TopRatedTVsPage()));
      expect(find.byKey(const Key('error_message')), findsOneWidget);
    });
  });

  group('AiringTodayTVsPage', () {
    late MockAiringTodayTVsBloc mockBloc;
    late StreamController<AiringTodayTVsState> streamController;

    setUp(() {
      mockBloc = MockAiringTodayTVsBloc();
      streamController = StreamController<AiringTodayTVsState>.broadcast();
      when(mockBloc.stream).thenAnswer((_) => streamController.stream);
    });

    tearDown(() {
      streamController.close();
    });

    Widget makeTestable(Widget body) {
      return BlocProvider<AiringTodayTVsBloc>.value(
        value: mockBloc,
        child: MaterialApp(home: body),
      );
    }

    testWidgets('should display progress bar when loading', (
      WidgetTester tester,
    ) async {
      when(mockBloc.state)
          .thenReturn(const AiringTodayTVsState(state: RequestState.loading));
      await tester.pumpWidget(makeTestable(const AiringTodayTVsPage()));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display ListView when loaded', (
      WidgetTester tester,
    ) async {
      when(mockBloc.state).thenReturn(
        const AiringTodayTVsState(state: RequestState.loaded, tvs: []),
      );
      await tester.pumpWidget(makeTestable(const AiringTodayTVsPage()));
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should display error message when Error', (
      WidgetTester tester,
    ) async {
      when(mockBloc.state).thenReturn(
        const AiringTodayTVsState(
          state: RequestState.error,
          message: 'Error message',
        ),
      );
      await tester.pumpWidget(makeTestable(const AiringTodayTVsPage()));
      expect(find.byKey(const Key('error_message')), findsOneWidget);
    });
  });

  group('OnTheAirTVsPage', () {
    late MockOnTheAirTVsBloc mockBloc;
    late StreamController<OnTheAirTVsState> streamController;

    setUp(() {
      mockBloc = MockOnTheAirTVsBloc();
      streamController = StreamController<OnTheAirTVsState>.broadcast();
      when(mockBloc.stream).thenAnswer((_) => streamController.stream);
    });

    tearDown(() {
      streamController.close();
    });

    Widget makeTestable(Widget body) {
      return BlocProvider<OnTheAirTVsBloc>.value(
        value: mockBloc,
        child: MaterialApp(home: body),
      );
    }

    testWidgets('should display progress bar when loading', (
      WidgetTester tester,
    ) async {
      when(mockBloc.state)
          .thenReturn(const OnTheAirTVsState(state: RequestState.loading));
      await tester.pumpWidget(makeTestable(const OnTheAirTVsPage()));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display ListView when loaded', (
      WidgetTester tester,
    ) async {
      when(
        mockBloc.state,
      ).thenReturn(const OnTheAirTVsState(state: RequestState.loaded, tvs: []));
      await tester.pumpWidget(makeTestable(const OnTheAirTVsPage()));
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should display error message when Error', (
      WidgetTester tester,
    ) async {
      when(mockBloc.state).thenReturn(
        const OnTheAirTVsState(
          state: RequestState.error,
          message: 'Error message',
        ),
      );
      await tester.pumpWidget(makeTestable(const OnTheAirTVsPage()));
      expect(find.byKey(const Key('error_message')), findsOneWidget);
    });
  });
}
