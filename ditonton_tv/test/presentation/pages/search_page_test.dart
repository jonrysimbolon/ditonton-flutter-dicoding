import 'dart:async';

import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_tv/presentation/bloc/tv_search_bloc.dart';
import 'package:ditonton_tv/presentation/pages/search_tv_page.dart';
import 'package:ditonton_tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects_tv.dart';
import 'search_page_test.mocks.dart';

@GenerateMocks([TVSearchBloc])
void main() {
  late MockTVSearchBloc mockTvSearchBloc;
  late StreamController<TVSearchState> streamController;

  setUp(() {
    mockTvSearchBloc = MockTVSearchBloc();
    streamController = StreamController<TVSearchState>.broadcast();
    when(mockTvSearchBloc.stream).thenAnswer((_) => streamController.stream);
    when(mockTvSearchBloc.state).thenReturn(const TVSearchState());
  });

  tearDown(() {
    streamController.close();
  });

  group('SearchTVPage debounce', () {
    test('events support value equality', () {
      expect(const TVSearchEvent(), const TVSearchEvent());
    });
    Widget makeTestable() {
      return BlocProvider<TVSearchBloc>.value(
        value: mockTvSearchBloc,
        child: const MaterialApp(home: SearchTVPage()),
      );
    }

    testWidgets('fetches once after typing stops for 500ms', (tester) async {
      await tester.pumpWidget(makeTestable());

      await tester.enterText(find.byType(TextField), 'breaking');
      await tester.pump(const Duration(milliseconds: 200));
      verifyNever(mockTvSearchBloc.add(any));

      await tester.enterText(find.byType(TextField), 'breaking bad');
      await tester.pump(const Duration(milliseconds: 500));

      verify(mockTvSearchBloc.add(const FetchTVSearch('breaking bad')))
          .called(1);
    });

    testWidgets('enter submits immediately without waiting', (tester) async {
      await tester.pumpWidget(makeTestable());

      await tester.enterText(find.byType(TextField), 'breaking');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();

      verify(mockTvSearchBloc.add(const FetchTVSearch('breaking'))).called(1);
    });

    testWidgets('shows result list when loaded with data', (tester) async {
      when(mockTvSearchBloc.state).thenReturn(
        const TVSearchState(state: RequestState.loaded, searchResult: [testTv]),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<TVSearchBloc>.value(
            value: mockTvSearchBloc,
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
