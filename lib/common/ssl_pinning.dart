import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

/// Builds an [http.Client] that only trusts the TMDB certificate chain,
/// implementing SSL pinning. Any server whose certificate does not chain to
/// the pinned Amazon intermediate CA (bundled in `certificates/themoviedb.pem`)
/// is rejected during the TLS handshake, blocking man-in-the-middle proxies.
class SSLPinning {
  static const _certificateAsset = 'certificates/themoviedb.pem';

  /// Creates a fresh pinned client. Loads the trusted certificate from the
  /// bundled asset and wires it into a [SecurityContext] with the system trust
  /// store disabled so only the pinned chain is accepted.
  static Future<http.Client> createClient() async {
    final sslCert = await rootBundle.load(_certificateAsset);

    final securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asUint8List());

    final httpClient = HttpClient(context: securityContext);
    // Reject any certificate that fails validation against the pinned context.
    httpClient.badCertificateCallback = (cert, host, port) => false;

    return IOClient(httpClient);
  }
}
