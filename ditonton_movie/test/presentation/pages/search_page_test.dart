import 'dart:async';

import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_movie/presentation/bloc/movie_search_bloc.dart';
import 'package:ditonton_movie/presentation/pages/search_page.dart';
import 'package:ditonton_movie/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'search_page_test.mocks.dart';

@GenerateMocks([MovieSearchBloc])
void main() {
  late MockMovieSearchBloc mockMovieSearchBloc;
  late StreamController<MovieSearchState> streamController;

  setUp(() {
    mockMovieSearchBloc = MockMovieSearchBloc();
    streamController = StreamController<MovieSearchState>.broadcast();
    when(mockMovieSearchBloc.stream).thenAnswer((_) => streamController.stream);
    when(mockMovieSearchBloc.state).thenReturn(const MovieSearchState());
  });

  tearDown(() {
    streamController.close();
  });

  group('SearchPage debounce', () {
    test('events support value equality', () {
      expect(MovieSearchEvent(), MovieSearchEvent());
      expect(FetchMovieSearch('a'), FetchMovieSearch('a'));
    });
    Widget makeTestable() {
      return BlocProvider<MovieSearchBloc>.value(
        value: mockMovieSearchBloc,
        child: const MaterialApp(home: SearchPage()),
      );
    }

    testWidgets('fetches once after typing stops for 500ms', (tester) async {
      await tester.pumpWidget(makeTestable());

      await tester.enterText(find.byType(TextField), 'spider');
      await tester.pump(const Duration(milliseconds: 200));
      verifyNever(mockMovieSearchBloc.add(any));

      await tester.enterText(find.byType(TextField), 'spiderman');
      await tester.pump(const Duration(milliseconds: 500));

      verify(mockMovieSearchBloc.add(const FetchMovieSearch('spiderman')))
          .called(1);
    });

    testWidgets('enter submits immediately without waiting', (tester) async {
      await tester.pumpWidget(makeTestable());

      await tester.enterText(find.byType(TextField), 'spider');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();

      verify(mockMovieSearchBloc.add(const FetchMovieSearch('spider')))
          .called(1);
    });

    testWidgets('shows result list when loaded with data', (tester) async {
      when(mockMovieSearchBloc.state).thenReturn(
        const MovieSearchState(
          state: RequestState.loaded,
          searchResult: [testMovie],
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<MovieSearchBloc>.value(
            value: mockMovieSearchBloc,
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
}
