import 'dart:async';
import 'dart:io' show Platform;

import 'package:firebase_analytics/firebase_analytics.dart';

/// Sends a custom event to Firebase Analytics.
///
/// Safe for tests: it is a no-op while running under `flutter test` so widget
/// tests never touch the Firebase platform channel.
void logAnalyticsEvent(String name, {Map<String, Object>? parameters}) {
  if (Platform.environment['FLUTTER_TEST'] == 'true') return;
  unawaited(
    FirebaseAnalytics.instance.logEvent(name: name, parameters: parameters),
  );
}
