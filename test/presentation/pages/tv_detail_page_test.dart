import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects_tv.dart';
import 'tv_detail_page_test.mocks.dart';

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

  testWidgets(
    'Watchlist button should display add icon when tv not added to watchlist',
    (WidgetTester tester) async {
      when(mockNotifier.tvState).thenReturn(RequestState.loaded);
      when(mockNotifier.tv).thenReturn(testTvDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
      when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);

      final watchlistButtonIcon = find.byIcon(Icons.add);

      await tester.pumpWidget(makeTestable(const TVDetailPage(id: 1)));
      await tester.pump();

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display check icon when tv is added to watchlist',
    (WidgetTester tester) async {
      when(mockNotifier.tvState).thenReturn(RequestState.loaded);
      when(mockNotifier.tv).thenReturn(testTvDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
      when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(true);

      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester.pumpWidget(makeTestable(const TVDetailPage(id: 1)));
      await tester.pump();

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (WidgetTester tester) async {
      when(mockNotifier.tvState).thenReturn(RequestState.loaded);
      when(mockNotifier.tv).thenReturn(testTvDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
      when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);
      when(mockNotifier.watchlistMessage).thenReturn('Added to Watchlist');

      final watchlistButton = find.byType(FilledButton);

      await tester.pumpWidget(makeTestable(const TVDetailPage(id: 1)));
      await tester.pump();

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Added to Watchlist'), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display AlertDialog when add to watchlist failed',
    (WidgetTester tester) async {
      when(mockNotifier.tvState).thenReturn(RequestState.loaded);
      when(mockNotifier.tv).thenReturn(testTvDetail);
      when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
      when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
      when(mockNotifier.isAddedToWatchlist).thenReturn(false);
      when(mockNotifier.watchlistMessage).thenReturn('Failed');

      final watchlistButton = find.byType(FilledButton);

      await tester.pumpWidget(makeTestable(const TVDetailPage(id: 1)));
      await tester.pump();

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    },
  );

  testWidgets('should display seasons section when detail loaded', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.tvState).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    await tester.pumpWidget(makeTestable(const TVDetailPage(id: 1)));
    await tester.pump();

    expect(find.text('Seasons'), findsOneWidget);
    expect(find.text('Recommendations'), findsOneWidget);
    expect(find.text('Season 1'), findsOneWidget);
  });

  testWidgets('should display progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.tvState).thenReturn(RequestState.loading);

    await tester.pumpWidget(makeTestable(const TVDetailPage(id: 1)));

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('should display message when error', (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.error);
    when(mockNotifier.message).thenReturn('Error message');

    await tester.pumpWidget(makeTestable(const TVDetailPage(id: 1)));

    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('should display message when recommendations error', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.tvState).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
    when(mockNotifier.recommendationState).thenReturn(RequestState.error);
    when(mockNotifier.message).thenReturn('Rec error');
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    await tester.pumpWidget(makeTestable(const TVDetailPage(id: 1)));
    await tester.pump();

    expect(find.text('Rec error'), findsOneWidget);
  });

  testWidgets('season tap navigates to season page', (
    WidgetTester tester,
  ) async {
    when(mockNotifier.tvState).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<TVDetailNotifier>.value(
          value: mockNotifier,
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
    when(mockNotifier.tvState).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
    when(mockNotifier.tvRecommendations).thenReturn([testTv]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<TVDetailNotifier>.value(
          value: mockNotifier,
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
    when(mockNotifier.tvState).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(true);
    when(mockNotifier.watchlistMessage).thenReturn('Removed from Watchlist');

    await tester.pumpWidget(makeTestable(const TVDetailPage(id: 1)));
    await tester.pump();

    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Removed from Watchlist'), findsOneWidget);
  });

  testWidgets('back button pops the page', (WidgetTester tester) async {
    when(mockNotifier.tvState).thenReturn(RequestState.loaded);
    when(mockNotifier.tv).thenReturn(testTvDetail);
    when(mockNotifier.recommendationState).thenReturn(RequestState.loaded);
    when(mockNotifier.tvRecommendations).thenReturn(<TV>[]);
    when(mockNotifier.isAddedToWatchlist).thenReturn(false);

    await tester.pumpWidget(makeTestable(const TVDetailPage(id: 1)));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
  });
}
