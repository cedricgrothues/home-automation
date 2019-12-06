import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

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
      throw PortError();
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

  /// Default API gateway port (change if necessary)
  final int port = 4000;

  // A lower timeout of 200ms is used, since approx. 255 of 256 port are expected time out, causing huge delays
  final Stream<NetworkAddress> stream = NetworkAnalyzer.discover(subnet, port, timeout: Duration(milliseconds: 100));
  await for (NetworkAddress addr in stream) {
    if (addr == null || !addr.exists) continue;

    http.Response response = await http.get("http://${addr.address}:$port/");

    if (response.statusCode != 200) continue;

    Map map = json.decode(response.body);

    if (!map.containsKey("name") || map["name"] != "service.api-gateway") continue;

    return addr.address;
  }

  return "not_found";
}
