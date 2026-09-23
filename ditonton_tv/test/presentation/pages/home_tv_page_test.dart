import 'dart:async';

import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_tv/presentation/bloc/tv_list_bloc.dart';
import 'package:ditonton_tv/presentation/pages/home_tv_page.dart';
import 'package:ditonton_tv/presentation/widgets/tv_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects_tv.dart';
import 'home_tv_page_test.mocks.dart';

@GenerateMocks([TVListBloc])
void main() {
  group('HomeTVPage', () {
    late MockTVListBloc mockTvListBloc;
    late StreamController<TVListState> streamController;

    setUp(() {
      mockTvListBloc = MockTVListBloc();
      streamController = StreamController<TVListState>.broadcast();
      when(mockTvListBloc.stream).thenAnswer((_) => streamController.stream);
      when(mockTvListBloc.state).thenReturn(const TVListState());
    });

    tearDown(() {
      streamController.close();
    });

    Widget makeTestable(Widget home) {
      return BlocProvider<TVListBloc>.value(
        value: mockTvListBloc,
        child: MaterialApp(
          home: home,
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (_) => const Scaffold(body: Text('stub route')),
          ),
        ),
      );
    }

    testWidgets('shows all tv categories', (tester) async {
      when(mockTvListBloc.state).thenReturn(
        const TVListState(
          airingTodayState: RequestState.loaded,
          onTheAirState: RequestState.loaded,
          popularTvsState: RequestState.loaded,
          topRatedTvsState: RequestState.loaded,
        ),
      );

      await tester.pumpWidget(makeTestable(const HomeTVPage()));
      await tester.pump();

      expect(find.text('TV Series'), findsOneWidget);
      expect(find.text('Airing Today'), findsOneWidget);
      expect(find.text('On The Air'), findsOneWidget);
      expect(find.text('Popular'), findsOneWidget);
      expect(find.text('Top Rated'), findsOneWidget);
    });

    testWidgets('shows progress bars when loading', (tester) async {
      when(mockTvListBloc.state).thenReturn(
        const TVListState(
          airingTodayState: RequestState.loading,
          onTheAirState: RequestState.loading,
          popularTvsState: RequestState.loading,
          topRatedTvsState: RequestState.loading,
        ),
      );

      await tester.pumpWidget(makeTestable(const HomeTVPage()));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('tv tap navigates to detail', (tester) async {
      when(mockTvListBloc.state).thenReturn(
        const TVListState(
          airingTodayState: RequestState.loaded,
          airingTodayTvs: [testTv],
          onTheAirState: RequestState.loaded,
          popularTvsState: RequestState.loaded,
          topRatedTvsState: RequestState.loaded,
        ),
      );

      await tester.pumpWidget(makeTestable(const HomeTVPage()));
      await tester.pump();
      await tester.pump();

      final cardTap = find.descendant(
        of: find.byType(TVList),
        matching: find.byType(InkWell),
      );
      await tester.tap(cardTap.first);
      await tester.pumpAndSettle();
      expect(find.text('stub route'), findsOneWidget);
    });

    testWidgets('search icon opens tv search', (tester) async {
      await tester.pumpWidget(makeTestable(const HomeTVPage()));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();
      expect(find.text('stub route'), findsOneWidget);
    });

    testWidgets('initState fetches all tv categories', (tester) async {
      when(mockTvListBloc.state).thenReturn(const TVListState());

      await tester.pumpWidget(makeTestable(const HomeTVPage()));
      await tester.pump();

      verify(mockTvListBloc.add(const FetchAiringTodayTvsList())).called(1);
      verify(mockTvListBloc.add(const FetchOnTheAirTvsList())).called(1);
      verify(mockTvListBloc.add(const FetchPopularTvsList())).called(1);
      verify(mockTvListBloc.add(const FetchTopRatedTvsList())).called(1);
    });

    testWidgets('see more navigates for each tv category', (tester) async {
      when(mockTvListBloc.state).thenReturn(
        const TVListState(
          airingTodayState: RequestState.loaded,
          onTheAirState: RequestState.loaded,
          popularTvsState: RequestState.loaded,
          topRatedTvsState: RequestState.loaded,
        ),
      );

      await tester.pumpWidget(makeTestable(const HomeTVPage()));
      await tester.pump();

      expect(find.text('See More'), findsNWidgets(4));
      for (var i = 0; i < 4; i++) {
        await tester.ensureVisible(find.text('See More').at(i));
        await tester.pump();
        await tester.tap(find.text('See More').at(i));
        await tester.pumpAndSettle();
        expect(find.text('stub route'), findsOneWidget);
        final ctx = tester.element(find.text('stub route'));
        Navigator.of(ctx).pop();
        await tester.pumpAndSettle();
      }
    });
  });
}
