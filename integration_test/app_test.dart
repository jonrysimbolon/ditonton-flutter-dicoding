import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/main.dart';
import 'package:ditonton_movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:ditonton_tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:ditonton_movie/presentation/pages/movie_detail_page.dart';
import 'package:ditonton_tv/presentation/pages/tv_detail_page.dart';
import 'package:ditonton_movie/presentation/widgets/movie_card_list.dart';
import 'package:ditonton_movie/presentation/widgets/movie_list.dart';
import 'package:ditonton_tv/presentation/widgets/tv_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

Future<void> pumpFor(WidgetTester tester, Duration duration) async {
  await Future<void>.delayed(duration);
  await tester.pump();
}

Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 45),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    await pumpFor(tester, const Duration(milliseconds: 500));
    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }
  fail('Tidak menemukan: $finder dalam waktu $timeout');
}

Future<void> tapToDetail(
  WidgetTester tester,
  Finder source,
  Finder target,
) async {
  for (var attempt = 0; attempt < 2; attempt++) {
    await tester.tap(source.first, warnIfMissed: false);
    await pumpFor(tester, const Duration(milliseconds: 300));
    final deadline = DateTime.now().add(const Duration(seconds: 20));
    while (DateTime.now().isBefore(deadline)) {
      await pumpFor(tester, const Duration(milliseconds: 500));
      if (target.evaluate().isNotEmpty) {
        return;
      }
    }
  }
  fail('Tidak bisa membuka detail dari $source menuju $target');
}

Future<void> openDrawer(WidgetTester tester) async {
  await pumpUntilFound(tester, find.byIcon(Icons.menu));
  await tester.tap(find.byIcon(Icons.menu));
  await pumpFor(tester, const Duration(milliseconds: 600));
}

Future<void> selectFromDrawer(WidgetTester tester, String label) async {
  await openDrawer(tester);
  final drawer = find.byType(Drawer);
  await tester.tap(find.descendant(of: drawer, matching: find.text(label)));
  await pumpFor(tester, const Duration(milliseconds: 600));
}

Future<String> movieNameOf(WidgetTester tester) async {
  final ctx = tester.element(find.byType(MovieDetailPage).first);
  return ctx.read<MovieDetailBloc>().state.movie!.title;
}

Future<String> tvNameOf(WidgetTester tester) async {
  final ctx = tester.element(find.byType(TVDetailPage).first);
  return ctx.read<TVDetailBloc>().state.tv!.name;
}

Future<void> goHomeBack(WidgetTester tester) async {
  await selectFromDrawer(tester, 'Movies');
  await pumpUntilFound(tester, find.byType(MovieList));
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    di.init();
  });

  testWidgets(
    'alur film: home memuat, detail menampilkan info, dan masuk watchlist',
    (tester) async {
      await tester.pumpWidget(const MyApp());

      await pumpUntilFound(tester, find.byType(MovieList));
      expect(find.text('Now Playing'), findsOneWidget);

      await tapToDetail(
        tester,
        find.byType(MovieList),
        find.widgetWithText(ElevatedButton, 'Watchlist'),
      );
      final firstName = await movieNameOf(tester);
      expect(find.text(firstName), findsWidgets);

      await tester.tap(find.widgetWithText(ElevatedButton, 'Watchlist').first);
      await pumpUntilFound(
        tester,
        find.text(MovieDetailState.watchlistAddSuccessMessage),
      );

      await tester.tap(find.byIcon(Icons.arrow_back).hitTestable().first);
      await pumpUntilFound(tester, find.byType(MovieList));

      await selectFromDrawer(tester, 'Watchlist');
      await pumpUntilFound(tester, find.text(firstName));
      expect(find.text(firstName), findsWidgets);

      await goHomeBack(tester);
    },
  );

  testWidgets(
    'alur TV: detail menampilkan season & episode, lalu masuk watchlist TV',
    (tester) async {
      await tester.pumpWidget(const MyApp());

      await pumpUntilFound(tester, find.byType(MovieList));
      await selectFromDrawer(tester, 'TV Series');
      await pumpUntilFound(tester, find.byType(TVList));
      expect(find.text('Airing Today'), findsOneWidget);

      await tapToDetail(
        tester,
        find.byType(TVList),
        find.widgetWithText(FilledButton, 'Watchlist'),
      );
      final tvName = await tvNameOf(tester);
      expect(find.text(tvName), findsWidgets);

      await tester.tap(find.widgetWithText(FilledButton, 'Watchlist').first);
      await pumpUntilFound(
        tester,
        find.text(TVDetailState.watchlistAddSuccessMessage),
      );

      final episodeFinder = find.textContaining('episodes').hitTestable();
      for (var i = 0; i < 12 && episodeFinder.evaluate().isEmpty; i++) {
        await tester.drag(
          find.byType(SingleChildScrollView).first,
          const Offset(0, -400),
        );
        await pumpFor(tester, const Duration(milliseconds: 250));
      }
      await tester.tap(episodeFinder.first);

      await pumpUntilFound(tester, find.textContaining('Episodes ('));
      await pumpUntilFound(tester, find.textContaining('Rating:'));

      await tester.tap(find.byType(BackButton).hitTestable().first);
      await pumpUntilFound(
        tester,
        find.widgetWithText(FilledButton, 'Watchlist'),
      );
      await tester.tap(find.byIcon(Icons.arrow_back).hitTestable().first);
      await pumpUntilFound(tester, find.byType(TVList));

      await selectFromDrawer(tester, 'Watchlist');
      await pumpUntilFound(tester, find.byType(TabBar));
      await tester.tap(
        find
            .descendant(
              of: find.byType(TabBar),
              matching: find.text('TV Series'),
            )
            .first,
      );
      await pumpUntilFound(tester, find.text(tvName));
      expect(find.text(tvName), findsWidgets);

      await goHomeBack(tester);
    },
  );

  testWidgets('pencarian film menghasilkan hasil dari API', (tester) async {
    await tester.pumpWidget(const MyApp());

    await pumpUntilFound(tester, find.byType(MovieList));
    await tester.tap(find.byIcon(Icons.search));
    await pumpUntilFound(tester, find.byType(TextField));

    await tester.enterText(find.byType(TextField), 'spider');
    await pumpUntilFound(tester, find.byType(MovieCard));

    await tapToDetail(
      tester,
      find.byType(MovieCard),
      find.widgetWithText(ElevatedButton, 'Watchlist'),
    );

    await tester.tap(find.byIcon(Icons.arrow_back).hitTestable().first);
    await pumpUntilFound(tester, find.byType(TextField));
    await tester.tap(find.byIcon(Icons.arrow_back).hitTestable().first);
    await pumpUntilFound(tester, find.byType(MovieList));
  });

  testWidgets('halaman about menampilkan deskripsi aplikasi', (tester) async {
    await tester.pumpWidget(const MyApp());

    await pumpUntilFound(tester, find.byType(MovieList));
    await selectFromDrawer(tester, 'About');
    await pumpUntilFound(
      tester,
      find.textContaining('Ditonton merupakan sebuah aplikasi katalog film'),
    );
  });
}