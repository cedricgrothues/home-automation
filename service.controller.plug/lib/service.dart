import 'dart:io';

import 'package:router/router.dart';

import 'routes/device.dart' as device;

int port = Platform.environment['PORT'] ?? 4001;

main(List<String> args) {
  Router()
    ..get(r'^/device/\w+', handler: device.get)
    ..patch(r'^/device/\w+', handler: device.update)
    ..listen(port: port);
}
