import 'dart:async';

import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:ditonton_tv/presentation/pages/tv_season_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects_tv.dart';
import 'tv_season_page_test.mocks.dart';

@GenerateMocks([TVDetailBloc])
void main() {
  late MockTVDetailBloc mockBloc;
  late StreamController<TVDetailState> streamController;

  setUp(() {
    mockBloc = MockTVDetailBloc();
    streamController = StreamController<TVDetailState>.broadcast();
    when(mockBloc.stream).thenAnswer((_) => streamController.stream);
  });

  tearDown(() {
    streamController.close();
  });

  Widget makeTestable(Widget body) {
    return BlocProvider<TVDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('should display loading when state is Loading', (
    WidgetTester tester,
  ) async {
    when(
      mockBloc.state,
    ).thenReturn(const TVDetailState(seasonDetailState: RequestState.loading));

    await tester.pumpWidget(
      makeTestable(const TVSeasonPage(id: 1, seasonNumber: 1)),
    );

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('should display episodes when loaded', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      const TVDetailState(
        seasonDetailState: RequestState.loaded,
        seasonDetail: testSeasonDetail,
      ),
    );

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
    when(mockBloc.state).thenReturn(
      const TVDetailState(
        seasonDetailState: RequestState.error,
        message: 'Error message',
      ),
    );

    await tester.pumpWidget(
      makeTestable(const TVSeasonPage(id: 1, seasonNumber: 1)),
    );

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });

  testWidgets('should display empty container on initial state', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(const TVDetailState());

    await tester.pumpWidget(
      makeTestable(const TVSeasonPage(id: 1, seasonNumber: 1)),
    );
    await tester.pump();

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byKey(const Key('error_message')), findsNothing);
  });
}
