import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';

void logAnalyticsEvent(String name, {Map<String, Object>? parameters}) {
  if (Firebase.apps.isEmpty) return;
  unawaited(
    FirebaseAnalytics.instance.logEvent(name: name, parameters: parameters),
  );
}
