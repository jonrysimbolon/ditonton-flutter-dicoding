import 'package:ditonton/firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
  });

  test('android options expose the ditonton firebase project', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    final options = DefaultFirebaseOptions.currentPlatform;

    expect(options.projectId, 'ditonton-73fbb');
    expect(options.appId, '1:553626573718:android:972f9d5dcf7361255a1bb7');
    expect(options.messagingSenderId, '553626573718');
  });

  test('unsupported targets throw for firebase options', () {
    for (final target in [
      TargetPlatform.iOS,
      TargetPlatform.macOS,
      TargetPlatform.windows,
      TargetPlatform.linux,
      TargetPlatform.fuchsia,
    ]) {
      debugDefaultTargetPlatformOverride = target;

      expect(
        () => DefaultFirebaseOptions.currentPlatform,
        throwsUnsupportedError,
      );
    }
  });
}
