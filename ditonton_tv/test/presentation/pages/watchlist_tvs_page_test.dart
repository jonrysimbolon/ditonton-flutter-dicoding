import 'dart:async';

import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_core/common/utils.dart';
import 'package:ditonton_tv/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:ditonton_tv/presentation/pages/watchlist_tvs_page.dart';
import 'package:ditonton_tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects_tv.dart';
import 'watchlist_tvs_page_test.mocks.dart';

@GenerateMocks([WatchlistTVBloc])
void main() {
  group('WatchlistTVsPage', () {
    test('events support value equality', () {
      expect(const WatchlistTVEvent(), const WatchlistTVEvent());
    });
    late MockWatchlistTVBloc mockBloc;
    late StreamController<WatchlistTVState> streamController;

    setUp(() {
      mockBloc = MockWatchlistTVBloc();
      streamController = StreamController<WatchlistTVState>.broadcast();
      when(mockBloc.stream).thenAnswer((_) => streamController.stream);
    });

    tearDown(() {
      streamController.close();
    });

    Widget makeTestable() {
      return BlocProvider<WatchlistTVBloc>.value(
        value: mockBloc,
        child: MaterialApp(
          home: const WatchlistTVsPage(),
          navigatorObservers: [routeObserver],
        ),
      );
    }

    testWidgets('shows progress bar when loading', (tester) async {
      when(mockBloc.state).thenReturn(
        const WatchlistTVState(watchlistState: RequestState.loading),
      );

      await tester.pumpWidget(makeTestable());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message', (tester) async {
      when(mockBloc.state).thenReturn(
        const WatchlistTVState(
          watchlistState: RequestState.error,
          message: 'Error message',
        ),
      );

      await tester.pumpWidget(makeTestable());

      expect(find.byKey(const Key('error_message')), findsOneWidget);
    });

    testWidgets('shows list when loaded with data', (tester) async {
      when(mockBloc.state).thenReturn(
        const WatchlistTVState(
          watchlistState: RequestState.loaded,
          watchlistTvs: [testWatchlistTv],
        ),
      );

      await tester.pumpWidget(makeTestable());
      await tester.pump();

      expect(find.byType(TVCard), findsOneWidget);
    });

    testWidgets('refreshes when returning from another route', (tester) async {
      when(
        mockBloc.state,
      ).thenReturn(const WatchlistTVState(watchlistState: RequestState.loaded));

      await tester.pumpWidget(makeTestable());
      await tester.pump();

      final context = tester.element(find.byType(WatchlistTVsPage));
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const Scaffold()));
      await tester.pumpAndSettle();
      Navigator.of(context).pop();
      await tester.pumpAndSettle();

      verify(mockBloc.add(const FetchWatchlistTVs()))
          .called(greaterThanOrEqualTo(1));
    });
  });
}
