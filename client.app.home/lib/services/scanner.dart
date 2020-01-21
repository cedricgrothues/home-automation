import 'dart:io' show Socket, SocketException;

import 'package:http/http.dart' show get, Response;
import 'package:connectivity/connectivity.dart' show Connectivity;

import 'package:home/models/errors.dart';

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
      throw PortException();
    }

    for (int i = 1; i <= 256; i++) {
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

Future<String> discover() async {
  final String ip = await Connectivity().getWifiIP();
  final String subnet = ip.substring(0, ip.lastIndexOf('.'));

  /// Default api gateway port (update if necessary)
  final int port = 4000;

  // A lower timeout of 300ms is used, since approx. 255 of 256 port are expected time out, causing huge delays
  final Stream<NetworkAddress> stream = NetworkAnalyzer.discover(subnet, port, timeout: Duration(milliseconds: 300));
  await for (NetworkAddress addr in stream) {
    if (addr == null || !addr.exists) continue;

    Response response = await get("http://${addr.address}:$port/");

    // There is no need to decode the json response, we'll simply check
    // if the response body contains the service name
    if (response.statusCode != 200 || !response.body.contains("service.api-gateway")) continue;

    return addr.address;
  }

  throw NotFoundException();
}
