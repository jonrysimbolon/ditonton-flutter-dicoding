import 'package:crypto/crypto.dart' show sha256;

import 'dart:convert' show base64Encode;
import 'dart:io'
    show HttpClient, HttpOverrides, SecurityContext, X509Certificate;

class PinnedHost {
  const PinnedHost(this.host, this.certificateFingerprint);

  final String host;
  final String certificateFingerprint;
}

const List<PinnedHost> pinnedHosts = [
  PinnedHost(
    'api.themoviedb.org',
    'MeRakVQvEcqSwpx5fOW99enPbUwCzWPyMwJewkPW5Zs=',
  ),
  PinnedHost('image.tmdb.org', 'gKsD4w1SZ4tjkA9X9OwysItV9HHXc5Ve9RcJPOsEJ+8='),
];

bool matchesPinnedFingerprint(String host, String fingerprint) {
  for (final entry in pinnedHosts) {
    if (entry.host == host) {
      return entry.certificateFingerprint == fingerprint;
    }
  }
  return true;
}

String certificateFingerprint(X509Certificate certificate) {
  return base64Encode(sha256.convert(certificate.der).bytes);
}

class SslPinningHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.badCertificateCallback = (cert, host, _) {
      return matchesPinnedFingerprint(host, certificateFingerprint(cert));
    };
    return client;
  }
}
