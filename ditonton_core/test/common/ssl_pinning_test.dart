import 'package:ditonton_core/common/ssl_pinning.dart';
import 'package:flutter_test/flutter_test.dart';

import 'dart:io';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('matchesPinnedFingerprint', () {
    test('returns true when fingerprint matches the pinned host', () {
      final result = matchesPinnedFingerprint(
        'api.themoviedb.org',
        'MeRakVQvEcqSwpx5fOW99enPbUwCzWPyMwJewkPW5Zs=',
      );
      expect(result, isTrue);
    });

    test('returns false when fingerprint differs from the pinned host', () {
      final result = matchesPinnedFingerprint(
        'api.themoviedb.org',
        'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=',
      );
      expect(result, isFalse);
    });

    test('returns true for hosts that are not pinned', () {
      final result = matchesPinnedFingerprint('unpinned.example.com', 'nope=');
      expect(result, isTrue);
    });
  });

  group('SslPinningHttpOverrides', () {
    test(
      'accepts self-signed localhost certificate (host not pinned)',
      () async {
        final cert = File('test/fixtures/tls_cert.pem').readAsStringSync();
        final key = File('test/fixtures/tls_key.pem').readAsStringSync();
        final securityContext = SecurityContext()
          ..useCertificateChainBytes(cert.codeUnits)
          ..usePrivateKeyBytes(key.codeUnits);

        final server = await HttpServer.bindSecure(
          InternetAddress.loopbackIPv4,
          0,
          securityContext,
        );
        addTearDown(() => server.close(force: true));
        server.listen((request) {
          request.response
            ..statusCode = HttpStatus.ok
            ..write('secure')
            ..close();
        });

        HttpOverrides.global = SslPinningHttpOverrides();
        final client = HttpClient();
        addTearDown(client.close);

        final request = await client.getUrl(
          Uri.parse('https://localhost:${server.port}/'),
        );
        final response = await request.close();
        expect(response.statusCode, HttpStatus.ok);
      },
    );
  });
}
