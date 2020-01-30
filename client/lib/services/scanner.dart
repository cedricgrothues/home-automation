import 'dart:io' show Socket, SocketException;

import 'package:http/http.dart' show get;
import 'package:connectivity/connectivity.dart' show Connectivity;

import 'package:home/models/errors.dart' show NotFoundException, PortException;

@deprecated
class NetworkAddress {
  const NetworkAddress(this.address, {this.exists = true});

  final String address;
  final bool exists;
}

@deprecated
class NetworkAnalyzer {
  static Stream<NetworkAddress> discover(
    String subnet,
    int port, {
    Duration timeout = const Duration(milliseconds: 400),
  }) async* {
    if (port < 1 || port > 65535) {
      throw PortException();
    }

    for (var i = 1; i <= 256; i++) {
      final host = '$subnet.$i';

      try {
        final s = await Socket.connect(host, port, timeout: timeout);
        s.destroy();
        yield NetworkAddress(host);
      } catch (e) {
        if (e is! SocketException) {
          rethrow;
        }

        yield NetworkAddress(host, exists: false);
      }
    }
  }
}

/// Used to disover the home hub within the device's subnet
@Deprecated("use the hub's local address (http://hub.local) instead")
Future<String> discover() async {
  final ip = await Connectivity().getWifiIP();
  final subnet = ip.substring(0, ip.lastIndexOf('.'));

  /// Default api gateway port (update if necessary)
  const port = 4000;

  // A lower timeout of 300ms is used, since approx. 255 of 256 port are expected time out, causing huge delays
  final stream = NetworkAnalyzer.discover(subnet, port, timeout: const Duration(milliseconds: 300));
  await for (final NetworkAddress addr in stream) {
    if (addr == null || !addr.exists) continue;

    final response = await get('http://${addr.address}:$port/');

    // There is no need to decode the json response, we'll simply check
    // if the response body contains the service name
    if (response.statusCode != 200 || !response.body.contains('core.api-gateway')) continue;

    return addr.address;
  }

  throw NotFoundException();
}
