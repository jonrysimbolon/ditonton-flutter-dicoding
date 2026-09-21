import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/pages/airing_today_tvs_page.dart';
import 'package:ditonton/presentation/pages/on_the_air_tvs_page.dart';
import 'package:ditonton/presentation/pages/popular_tvs_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tvs_page.dart';
import 'package:ditonton/presentation/provider/airing_today_tvs_notifier.dart';
import 'package:ditonton/presentation/provider/on_the_air_tvs_notifier.dart';
import 'package:ditonton/presentation/provider/popular_tvs_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_tvs_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'tv_pages_test.mocks.dart';

@GenerateMocks([
  PopularTVsNotifier,
  TopRatedTVsNotifier,
  AiringTodayTVsNotifier,
  OnTheAirTVsNotifier,
])
void main() {
  group('PopularTVsPage', () {
    late MockPopularTVsNotifier mockNotifier;

    setUp(() {
      mockNotifier = MockPopularTVsNotifier();
    });

    Widget makeTestable(Widget body) {
      return ChangeNotifierProvider<PopularTVsNotifier>.value(
        value: mockNotifier,
        child: MaterialApp(home: body),
      );
    }

    testWidgets('should display progress bar when loading', (
      WidgetTester tester,
    ) async {
      when(mockNotifier.state).thenReturn(RequestState.loading);
      await tester.pumpWidget(makeTestable(const PopularTVsPage()));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display ListView when loaded', (
      WidgetTester tester,
    ) async {
      when(mockNotifier.state).thenReturn(RequestState.loaded);
      when(mockNotifier.tvs).thenReturn(<TV>[]);
      await tester.pumpWidget(makeTestable(const PopularTVsPage()));
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should display error message when Error', (
      WidgetTester tester,
    ) async {
      when(mockNotifier.state).thenReturn(RequestState.error);
      when(mockNotifier.message).thenReturn('Error message');
      await tester.pumpWidget(makeTestable(const PopularTVsPage()));
      expect(find.byKey(const Key('error_message')), findsOneWidget);
    });
  });

  group('TopRatedTVsPage', () {
    late MockTopRatedTVsNotifier mockNotifier;

    setUp(() {
      mockNotifier = MockTopRatedTVsNotifier();
    });

    Widget makeTestable(Widget body) {
      return ChangeNotifierProvider<TopRatedTVsNotifier>.value(
        value: mockNotifier,
        child: MaterialApp(home: body),
      );
    }

    testWidgets('should display progress bar when loading', (
      WidgetTester tester,
    ) async {
      when(mockNotifier.state).thenReturn(RequestState.loading);
      await tester.pumpWidget(makeTestable(const TopRatedTVsPage()));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display ListView when loaded', (
      WidgetTester tester,
    ) async {
      when(mockNotifier.state).thenReturn(RequestState.loaded);
      when(mockNotifier.tvs).thenReturn(<TV>[]);
      await tester.pumpWidget(makeTestable(const TopRatedTVsPage()));
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should display error message when Error', (
      WidgetTester tester,
    ) async {
      when(mockNotifier.state).thenReturn(RequestState.error);
      when(mockNotifier.message).thenReturn('Error message');
      await tester.pumpWidget(makeTestable(const TopRatedTVsPage()));
      expect(find.byKey(const Key('error_message')), findsOneWidget);
    });
  });

  group('AiringTodayTVsPage', () {
    late MockAiringTodayTVsNotifier mockNotifier;

    setUp(() {
      mockNotifier = MockAiringTodayTVsNotifier();
    });

    Widget makeTestable(Widget body) {
      return ChangeNotifierProvider<AiringTodayTVsNotifier>.value(
        value: mockNotifier,
        child: MaterialApp(home: body),
      );
    }

    testWidgets('should display progress bar when loading', (
      WidgetTester tester,
    ) async {
      when(mockNotifier.state).thenReturn(RequestState.loading);
      await tester.pumpWidget(makeTestable(const AiringTodayTVsPage()));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display ListView when loaded', (
      WidgetTester tester,
    ) async {
      when(mockNotifier.state).thenReturn(RequestState.loaded);
      when(mockNotifier.tvs).thenReturn(<TV>[]);
      await tester.pumpWidget(makeTestable(const AiringTodayTVsPage()));
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should display error message when Error', (
      WidgetTester tester,
    ) async {
      when(mockNotifier.state).thenReturn(RequestState.error);
      when(mockNotifier.message).thenReturn('Error message');
      await tester.pumpWidget(makeTestable(const AiringTodayTVsPage()));
      expect(find.byKey(const Key('error_message')), findsOneWidget);
    });
  });

  group('OnTheAirTVsPage', () {
    late MockOnTheAirTVsNotifier mockNotifier;

    setUp(() {
      mockNotifier = MockOnTheAirTVsNotifier();
    });

    Widget makeTestable(Widget body) {
      return ChangeNotifierProvider<OnTheAirTVsNotifier>.value(
        value: mockNotifier,
        child: MaterialApp(home: body),
      );
    }

    testWidgets('should display progress bar when loading', (
      WidgetTester tester,
    ) async {
      when(mockNotifier.state).thenReturn(RequestState.loading);
      await tester.pumpWidget(makeTestable(const OnTheAirTVsPage()));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display ListView when loaded', (
      WidgetTester tester,
    ) async {
      when(mockNotifier.state).thenReturn(RequestState.loaded);
      when(mockNotifier.tvs).thenReturn(<TV>[]);
      await tester.pumpWidget(makeTestable(const OnTheAirTVsPage()));
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should display error message when Error', (
      WidgetTester tester,
    ) async {
      when(mockNotifier.state).thenReturn(RequestState.error);
      when(mockNotifier.message).thenReturn('Error message');
      await tester.pumpWidget(makeTestable(const OnTheAirTVsPage()));
      expect(find.byKey(const Key('error_message')), findsOneWidget);
    });
  });
}
