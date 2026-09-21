import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/tv_season_page.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects_tv.dart';
import 'tv_season_page_test.mocks.dart';

@GenerateMocks([TVDetailNotifier])
void main() {
  late MockTVDetailNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockTVDetailNotifier();
  });

  Widget makeTestable(Widget body) {
    return ChangeNotifierProvider<TVDetailNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('should display loading when state is Loading', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.seasonDetailState).thenReturn(RequestState.loading);

    await tester.pumpWidget(
      makeTestable(const TVSeasonPage(id: 1, seasonNumber: 1)),
    );

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('should display episodes when loaded', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.seasonDetailState).thenReturn(RequestState.loaded);
    when(mockNotifier.seasonDetail).thenReturn(testSeasonDetail);

    await tester.pumpWidget(
      makeTestable(const TVSeasonPage(id: 1, seasonNumber: 1)),
    );
    await tester.pump();

    expect(find.text('Season 1'), findsWidgets);
    expect(find.text('E1: Pilot'), findsOneWidget);
  });

  testWidgets('should display error message when Error', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.seasonDetailState).thenReturn(RequestState.error);
    when(mockNotifier.message).thenReturn('Error message');

    await tester.pumpWidget(
      makeTestable(const TVSeasonPage(id: 1, seasonNumber: 1)),
    );

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });

  testWidgets('should display empty container on initial state', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.seasonDetailState).thenReturn(RequestState.empty);

    await tester.pumpWidget(
      makeTestable(const TVSeasonPage(id: 1, seasonNumber: 1)),
    );
    await tester.pump();

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byKey(const Key('error_message')), findsNothing);
  });
}
