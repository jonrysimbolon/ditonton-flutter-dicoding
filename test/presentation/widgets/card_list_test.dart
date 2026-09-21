import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tMovie = Movie(
    adult: false,
    backdropPath: 'backdrop',
    genreIds: [1],
    id: 1,
    originalTitle: 'original',
    overview: 'overview text for movie card widget test',
    popularity: 1.0,
    posterPath: '/poster.jpg',
    releaseDate: '2023-01-01',
    title: 'Movie Title',
    video: false,
    voteAverage: 8.0,
    voteCount: 100,
  );

  const tTv = TV(
    backdropPath: 'backdrop',
    firstAirDate: '2023-01-01',
    genreIds: [1],
    id: 1,
    name: 'TV Title',
    originCountry: ['US'],
    originalName: 'TV Original',
    overview: 'overview text for tv card widget test',
    popularity: 1.0,
    posterPath: '/poster.jpg',
    voteAverage: 8.0,
    voteCount: 100,
  );

  testWidgets('MovieCard displays title and overview and navigates on tap', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const Scaffold(body: MovieCard(tMovie)),
        routes: {
          MovieDetailPage.routeName: (_) => Scaffold(
            appBar: AppBar(title: const Text('Detail')),
            body: const Text('Movie Detail'),
          ),
        },
        onGenerateRoute: (settings) {
          if (settings.name == MovieDetailPage.routeName) {
            return MaterialPageRoute(
              builder: (_) => const Scaffold(body: Text('Movie Detail')),
              settings: settings,
            );
          }
          return null;
        },
      ),
    );

    expect(find.text('Movie Title'), findsOneWidget);
    expect(find.textContaining('overview text'), findsOneWidget);

    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();
    expect(find.text('Movie Detail'), findsOneWidget);
  });

  testWidgets('TVCard displays name and overview and navigates on tap', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const Scaffold(body: TVCard(tTv)),
        onGenerateRoute: (settings) {
          if (settings.name == TVDetailPage.routeName) {
            return MaterialPageRoute(
              builder: (_) => const Scaffold(body: Text('TV Detail')),
              settings: settings,
            );
          }
          return null;
        },
      ),
    );

    expect(find.text('TV Title'), findsOneWidget);
    expect(find.textContaining('overview text'), findsOneWidget);

    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();
    expect(find.text('TV Detail'), findsOneWidget);
  });
}
