import 'dart:async';

import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_core/domain/entities/tv.dart';
import 'package:ditonton_tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:ditonton_tv/presentation/pages/tv_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects_tv.dart';
import 'tv_detail_page_test.mocks.dart';

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

  TVDetailState loadedState({
    RequestState recommendationState = RequestState.loaded,
    List<TV> recommendations = const [],
    bool isAdded = false,
  }) {
    return TVDetailState(
      tvState: RequestState.loaded,
      tv: testTvDetail,
      recommendationState: recommendationState,
      tvRecommendations: recommendations,
      isAddedToWatchlist: isAdded,
    );
  }

  testWidgets(
    'Watchlist button should display add icon when tv not added to watchlist',
    (WidgetTester tester) async {
      when(mockBloc.state).thenReturn(loadedState());

      final watchlistButtonIcon = find.byIcon(Icons.add);

      await tester.pumpWidget(makeTestable(const TVDetailPage(id: 1)));
      await tester.pump();

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display check icon when tv is added to watchlist',
    (WidgetTester tester) async {
      when(mockBloc.state).thenReturn(loadedState(isAdded: true));

      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester.pumpWidget(makeTestable(const TVDetailPage(id: 1)));
      await tester.pump();

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display SnackBar when added to watchlist',
    (WidgetTester tester) async {
      when(mockBloc.state).thenReturn(loadedState());

      final watchlistButton = find.byType(FilledButton);

      await tester.pumpWidget(makeTestable(const TVDetailPage(id: 1)));
      await tester.pump();

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton);

      final messageState = TVDetailState(
        tvState: RequestState.loaded,
        tv: testTvDetail,
        recommendationState: RequestState.loaded,
        watchlistMessage: TVDetailState.watchlistAddSuccessMessage,
      );
      when(mockBloc.state).thenReturn(messageState);
      streamController.add(messageState);
      await tester.pump();

      verify(mockBloc.add(AddTVWatchlist(testTvDetail))).called(1);
      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text(TVDetailState.watchlistAddSuccessMessage),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Watchlist button should display AlertDialog when add to watchlist failed',
    (WidgetTester tester) async {
      when(mockBloc.state).thenReturn(loadedState());

      final watchlistButton = find.byType(FilledButton);

      await tester.pumpWidget(makeTestable(const TVDetailPage(id: 1)));
      await tester.pump();

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton);

      final messageState = TVDetailState(
        tvState: RequestState.loaded,
        tv: testTvDetail,
        recommendationState: RequestState.loaded,
        watchlistMessage: 'Failed',
      );
      when(mockBloc.state).thenReturn(messageState);
      streamController.add(messageState);
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    },
  );

  testWidgets('should display seasons section when detail loaded', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(loadedState());

    await tester.pumpWidget(makeTestable(const TVDetailPage(id: 1)));
    await tester.pump();

    expect(find.text('Seasons'), findsOneWidget);
    expect(find.text('Recommendations'), findsOneWidget);
    expect(find.text('Season 1'), findsOneWidget);
  });

  testWidgets('should display progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state)
        .thenReturn(const TVDetailState(tvState: RequestState.loading));

    await tester.pumpWidget(makeTestable(const TVDetailPage(id: 1)));

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('should display message when error', (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(
      const TVDetailState(
        tvState: RequestState.error,
        message: 'Error message',
      ),
    );

    await tester.pumpWidget(makeTestable(const TVDetailPage(id: 1)));

    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('should display message when recommendations error', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      TVDetailState(
        tvState: RequestState.loaded,
        tv: testTvDetail,
        recommendationState: RequestState.error,
        message: 'Rec error',
        isAddedToWatchlist: false,
      ),
    );

    await tester.pumpWidget(makeTestable(const TVDetailPage(id: 1)));
    await tester.pump();

    expect(find.text('Rec error'), findsOneWidget);
  });

  testWidgets('season tap navigates to season page', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(loadedState());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<TVDetailBloc>.value(
          value: mockBloc,
          child: const TVDetailPage(id: 1),
        ),
        onGenerateRoute: (_) => MaterialPageRoute(
          builder: (_) => const Scaffold(body: Text('stub season')),
        ),
      ),
    );
    await tester.pump();

    final seasonTap = find.ancestor(
      of: find.text('Season 1'),
      matching: find.byType(InkWell),
    );
    tester.widget<InkWell>(seasonTap.first).onTap!();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('stub season'), findsOneWidget);
  });

  testWidgets('recommendation tap navigates to detail', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(loadedState(recommendations: [testTv]));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<TVDetailBloc>.value(
          value: mockBloc,
          child: const TVDetailPage(id: 1),
        ),
        onGenerateRoute: (_) => MaterialPageRoute(
          builder: (_) => const Scaffold(body: Text('stub detail')),
        ),
      ),
    );
    await tester.pump();

    final recTap = find.descendant(
      of: find.byType(ListView).last,
      matching: find.byType(InkWell),
    );
    tester.widget<InkWell>(recTap.first).onTap!();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('stub detail'), findsOneWidget);
  });

  testWidgets('watchlist button removes when tv already added', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(loadedState(isAdded: true));

    await tester.pumpWidget(makeTestable(const TVDetailPage(id: 1)));
    await tester.pump();

    await tester.tap(find.byType(FilledButton));

    final messageState = TVDetailState(
      tvState: RequestState.loaded,
      tv: testTvDetail,
      recommendationState: RequestState.loaded,
      isAddedToWatchlist: true,
      watchlistMessage: TVDetailState.watchlistRemoveSuccessMessage,
    );
    when(mockBloc.state).thenReturn(messageState);
    streamController.add(messageState);
    await tester.pump();

    verify(mockBloc.add(RemoveTVWatchlist(testTvDetail))).called(1);
    expect(find.byType(SnackBar), findsOneWidget);
    expect(
      find.text(TVDetailState.watchlistRemoveSuccessMessage),
      findsOneWidget,
    );
  });

  testWidgets('back button pops the page', (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(loadedState());

    await tester.pumpWidget(makeTestable(const TVDetailPage(id: 1)));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
  });
}
