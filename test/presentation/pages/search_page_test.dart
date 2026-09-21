import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/search_tv_page.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/presentation/provider/tv_search_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../dummy_data/dummy_objects_tv.dart';
import 'search_page_test.mocks.dart';

@GenerateMocks([MovieSearchNotifier, TVSearchNotifier])
void main() {
  late MockMovieSearchNotifier mockMovieSearchNotifier;
  late MockTVSearchNotifier mockTvSearchNotifier;

  setUp(() {
    mockMovieSearchNotifier = MockMovieSearchNotifier();
    mockTvSearchNotifier = MockTVSearchNotifier();
    when(mockMovieSearchNotifier.fetchMovieSearch(any))
        .thenAnswer((_) async {});
    when(mockMovieSearchNotifier.state).thenReturn(RequestState.empty);
    when(mockMovieSearchNotifier.searchResult).thenReturn([]);
    when(mockMovieSearchNotifier.message).thenReturn('');
    when(mockTvSearchNotifier.fetchTvSearch(any)).thenAnswer((_) async {});
    when(mockTvSearchNotifier.state).thenReturn(RequestState.empty);
    when(mockTvSearchNotifier.searchResult).thenReturn([]);
    when(mockTvSearchNotifier.message).thenReturn('');
  });

  group('SearchPage debounce', () {
    Widget makeTestable() {
      return ChangeNotifierProvider<MovieSearchNotifier>.value(
        value: mockMovieSearchNotifier,
        child: const MaterialApp(home: SearchPage()),
      );
    }

    testWidgets('fetches once after typing stops for 500ms', (tester) async {
      await tester.pumpWidget(makeTestable());

      await tester.enterText(find.byType(TextField), 'spider');
      await tester.pump(const Duration(milliseconds: 200));
      verifyNever(mockMovieSearchNotifier.fetchMovieSearch(any));

      await tester.enterText(find.byType(TextField), 'spiderman');
      await tester.pump(const Duration(milliseconds: 500));

      verify(mockMovieSearchNotifier.fetchMovieSearch('spiderman')).called(1);
    });

    testWidgets('enter submits immediately without waiting', (tester) async {
      await tester.pumpWidget(makeTestable());

      await tester.enterText(find.byType(TextField), 'spider');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();

      verify(mockMovieSearchNotifier.fetchMovieSearch('spider')).called(1);
    });

    testWidgets('shows result list when loaded with data', (tester) async {
      when(mockMovieSearchNotifier.state).thenReturn(RequestState.loaded);
      when(mockMovieSearchNotifier.searchResult).thenReturn([testMovie]);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<MovieSearchNotifier>.value(
            value: mockMovieSearchNotifier,
            child: const SearchPage(),
          ),
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (_) => const Scaffold(body: Text('stub detail')),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(MovieCard), findsOneWidget);

      await tester.tap(find.byType(MovieCard));
      await tester.pumpAndSettle();

      expect(find.text('stub detail'), findsOneWidget);
    });
  });

  group('SearchTVPage debounce', () {
    Widget makeTestable() {
      return ChangeNotifierProvider<TVSearchNotifier>.value(
        value: mockTvSearchNotifier,
        child: const MaterialApp(home: SearchTVPage()),
      );
    }

    testWidgets('fetches once after typing stops for 500ms', (tester) async {
      await tester.pumpWidget(makeTestable());

      await tester.enterText(find.byType(TextField), 'breaking');
      await tester.pump(const Duration(milliseconds: 200));
      verifyNever(mockTvSearchNotifier.fetchTvSearch(any));

      await tester.enterText(find.byType(TextField), 'breaking bad');
      await tester.pump(const Duration(milliseconds: 500));

      verify(mockTvSearchNotifier.fetchTvSearch('breaking bad')).called(1);
    });

    testWidgets('enter submits immediately without waiting', (tester) async {
      await tester.pumpWidget(makeTestable());

      await tester.enterText(find.byType(TextField), 'breaking');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();

      verify(mockTvSearchNotifier.fetchTvSearch('breaking')).called(1);
    });

    testWidgets('shows result list when loaded with data', (tester) async {
      when(mockTvSearchNotifier.state).thenReturn(RequestState.loaded);
      when(mockTvSearchNotifier.searchResult).thenReturn([testTv]);

      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<TVSearchNotifier>.value(
            value: mockTvSearchNotifier,
            child: const SearchTVPage(),
          ),
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (_) => const Scaffold(body: Text('stub detail')),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(TVCard), findsOneWidget);

      await tester.tap(find.byType(TVCard));
      await tester.pumpAndSettle();

      expect(find.text('stub detail'), findsOneWidget);
    });
  });
}
