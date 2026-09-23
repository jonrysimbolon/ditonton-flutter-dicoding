import 'package:ditonton_core/domain/entities/tv.dart';
import 'package:ditonton_tv/presentation/pages/tv_detail_page.dart';
import 'package:ditonton_tv/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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

  testWidgets('TVCard displays name and overview and navigates on tap', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const Scaffold(body: TVCard(tTv)),
        onGenerateRoute: (settings) {
          if (settings.name == TVDetailPage.routeName) {
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                appBar: AppBar(title: const Text('Detail')),
                body: const Text('TV Detail'),
              ),
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
