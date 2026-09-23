import 'package:ditonton/main.dart' as app;

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('main bootstraps the app', (tester) async {
    await app.main();

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(app.MyApp), findsOneWidget);
  });
}