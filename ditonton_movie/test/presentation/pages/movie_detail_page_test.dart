import 'dart:async';

import 'package:ditonton_core/common/state_enum.dart';
import 'package:ditonton_core/domain/entities/genre.dart';
import 'package:ditonton_core/domain/entities/movie.dart';
import 'package:ditonton_core/domain/entities/movie_detail.dart';
import 'package:ditonton_movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:ditonton_movie/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'movie_detail_page_test.mocks.dart';

@GenerateMocks([MovieDetailBloc])
void main() {
  late MockMovieDetailBloc mockBloc;
  late StreamController<MovieDetailState> streamController;

  setUp(() {
    mockBloc = MockMovieDetailBloc();
    streamController = StreamController<MovieDetailState>.broadcast();
    when(mockBloc.stream).thenAnswer((_) => streamController.stream);
  });

  tearDown(() {
    streamController.close();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  MovieDetailState loadedState({
    RequestState recommendationState = RequestState.loaded,
    List<Movie> recommendations = const [],
    bool isAdded = false,
  }) {
    return MovieDetailState(
      movieState: RequestState.loaded,
      movie: testMovieDetail,
      recommendationState: recommendationState,
      movieRecommendations: recommendations,
      isAddedToWatchlist: isAdded,
    );
  }

  testWidgets(
    'Watchlist button should display add icon when movie not added to watchlist',
    (WidgetTester tester) async {
      when(mockBloc.state).thenReturn(loadedState());

      final watchlistButtonIcon = find.byIcon(Icons.add);

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display check icon when movie is added to watchlist',
    (WidgetTester tester) async {
      when(mockBloc.state).thenReturn(loadedState(isAdded: true));

      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets('Watchlist button should add to watchlist and display SnackBar', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(loadedState());

    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);

    final messageState = MovieDetailState(
      movieState: RequestState.loaded,
      movie: testMovieDetail,
      recommendationState: RequestState.loaded,
      watchlistMessage: MovieDetailState.watchlistAddSuccessMessage,
    );
    when(mockBloc.state).thenReturn(messageState);
    streamController.add(messageState);
    await tester.pump();

    verify(mockBloc.add(AddMovieWatchlist(testMovieDetail))).called(1);
    expect(find.byType(SnackBar), findsOneWidget);
    expect(
      find.text(MovieDetailState.watchlistAddSuccessMessage),
      findsOneWidget,
    );
  });

  testWidgets(
    'Watchlist button should display AlertDialog when add to watchlist failed',
    (WidgetTester tester) async {
      when(mockBloc.state).thenReturn(loadedState());

      final watchlistButton = find.byType(ElevatedButton);

      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton);

      final messageState = MovieDetailState(
        movieState: RequestState.loaded,
        movie: testMovieDetail,
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

  testWidgets('Page should display progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state)
        .thenReturn(const MovieDetailState(movieState: RequestState.loading));

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('Page should display message when error', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      const MovieDetailState(
        movieState: RequestState.error,
        message: 'Error message',
      ),
    );

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.text('Error message'), findsOneWidget);
  });

  testWidgets('Recommendations should display progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state)
        .thenReturn(loadedState(recommendationState: RequestState.loading));

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('Recommendations should display message when error', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(
      MovieDetailState(
        movieState: RequestState.loaded,
        movie: testMovieDetail,
        recommendationState: RequestState.error,
        message: 'Rec error',
        isAddedToWatchlist: false,
      ),
    );

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.pump();

    expect(find.text('Rec error'), findsOneWidget);
  });

  testWidgets('Recommendation tap navigates to detail', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(loadedState(recommendations: [testMovie]));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<MovieDetailBloc>.value(
          value: mockBloc,
          child: const MovieDetailPage(id: 1),
        ),
        onGenerateRoute: (_) => MaterialPageRoute(
          builder: (_) => const Scaffold(body: Text('stub detail')),
        ),
      ),
    );
    await tester.pump();

    final inkwell = find.descendant(
      of: find.byType(ListView).last,
      matching: find.byType(InkWell),
    );
    tester.widget<InkWell>(inkwell.first).onTap!();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('stub detail'), findsOneWidget);
  });

  testWidgets('Watchlist button removes when movie already added', (
    WidgetTester tester,
  ) async {
    when(mockBloc.state).thenReturn(loadedState(isAdded: true));

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.pump();

    await tester.tap(find.byType(ElevatedButton));

    final messageState = MovieDetailState(
      movieState: RequestState.loaded,
      movie: testMovieDetail,
      recommendationState: RequestState.loaded,
      isAddedToWatchlist: true,
      watchlistMessage: MovieDetailState.watchlistRemoveSuccessMessage,
    );
    when(mockBloc.state).thenReturn(messageState);
    streamController.add(messageState);
    await tester.pump();

    verify(mockBloc.add(RemoveMovieWatchlist(testMovieDetail))).called(1);
    expect(find.byType(SnackBar), findsOneWidget);
    expect(
      find.text(MovieDetailState.watchlistRemoveSuccessMessage),
      findsOneWidget,
    );
  });

  testWidgets('Back button pops the page', (WidgetTester tester) async {
    when(mockBloc.state).thenReturn(loadedState());

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
  });

  testWidgets('Duration shows minutes only when under an hour', (
    WidgetTester tester,
  ) async {
    const shortMovie = MovieDetail(
      adult: false,
      backdropPath: 'backdropPath',
      genres: [Genre(id: 1, name: 'Action')],
      id: 1,
      originalTitle: 'originalTitle',
      overview: 'overview',
      posterPath: 'posterPath',
      releaseDate: 'releaseDate',
      runtime: 45,
      title: 'title',
      voteAverage: 1,
      voteCount: 1,
    );
    when(mockBloc.state).thenReturn(
      MovieDetailState(
        movieState: RequestState.loaded,
        movie: shortMovie,
        recommendationState: RequestState.loaded,
      ),
    );

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.pump();

    expect(find.text('45m'), findsOneWidget);
  });
}
