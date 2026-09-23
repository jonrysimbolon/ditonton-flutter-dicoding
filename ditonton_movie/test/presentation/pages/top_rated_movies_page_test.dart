import 'dart:async';

import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_movie/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:ditonton_movie/presentation/pages/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_movies_page_test.mocks.dart';

@GenerateMocks([TopRatedMoviesBloc])
void main() {
  late MockTopRatedMoviesBloc mockBloc;
  late StreamController<TopRatedMoviesState> streamController;

  setUp(() {
    mockBloc = MockTopRatedMoviesBloc();
    streamController = StreamController<TopRatedMoviesState>.broadcast();
    when(mockBloc.stream).thenAnswer((_) => streamController.stream);
  });

  tearDown(() {
    streamController.close();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMoviesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state)
        .thenReturn(const TopRatedMoviesState(state: RequestState.loading));

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      const TopRatedMoviesState(state: RequestState.loaded, movies: []),
    );

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      const TopRatedMoviesState(
        state: RequestState.error,
        message: 'Error message',
      ),
    );

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
