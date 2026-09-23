import 'package:ditonton_core/domain/entities/movie.dart';
import 'package:ditonton_movie/presentation/pages/movie_detail_page.dart';
import 'package:ditonton_movie/presentation/widgets/movie_card_list.dart';
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

  testWidgets('MovieCard displays title and overview and navigates on tap', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const Scaffold(body: MovieCard(tMovie)),
        onGenerateRoute: (settings) {
          if (settings.name == MovieDetailPage.routeName) {
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                appBar: AppBar(title: const Text('Detail')),
                body: const Text('Movie Detail'),
              ),
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
}
