/// Lookup IP Addresses on Device
import 'dart:async';
import 'dart:io';

class NetworkAddress {
  final String address;
  final bool exists;

  NetworkAddress(this.address, {this.exists = true});
}

class NetworkAnalyzer {
  static Stream<NetworkAddress> discover(
    String subnet,
    int port, {
    Duration timeout = const Duration(milliseconds: 400),
  }) async* {
    if (port < 1 || port > 65535) {
      throw 'Incorrect port';
    }

    for (int i = 1; i < 256; ++i) {
      final host = '$subnet.$i';

      try {
        final Socket s = await Socket.connect(host, port, timeout: timeout);
        s.destroy();
        yield NetworkAddress(host);
      } catch (e) {
        if (!(e is SocketException)) {
          rethrow;
        }

        yield NetworkAddress(host, exists: false);
      }
    }
  }
}
