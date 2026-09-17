import 'package:core/common/ssl_pinning.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SSLPinning', () {
    test('createClient loads the pinned certificate and returns an IOClient',
        () async {
      final client = await SSLPinning.createClient();

      addTearDown(client.close);
      expect(client, isA<http.Client>());
      expect(client, isA<IOClient>());
    });
  });
}
