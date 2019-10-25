import 'dart:io';

import 'routes/router.dart';
import 'routes/device.dart' as device;

int port = Platform.environment['PORT'] ?? 4001;

Future<void> main(List<String> args) async {
  Router(address: InternetAddress.loopbackIPv4, port: port)
    ..get(r'^/device/\w+', handler: device.get)
    ..patch(r'^/device/\w+', handler: device.update)
    ..listen();
}
