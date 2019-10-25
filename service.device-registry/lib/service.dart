import 'dart:io';

import 'package:router/router.dart';

import 'routes/devices.dart' as devices;
import 'routes/rooms.dart' as rooms;

int port = Platform.environment['PORT'] ?? 4000;

main(List<String> args) {
  Router router = Router();

  router.get('/devices', handler: devices.get);
  router.post('/devices', handler: devices.post);

  router.get(r'^/device/\w+$', handler: devices.lookup);
  router.delete(r'^/device/\w+$', handler: devices.delete);

  router.get('/rooms', handler: rooms.get);
  router.post('/rooms', handler: rooms.post);

  router.get(r'^/room/\w+$', handler: rooms.lookup);
  router.delete(r'^/room/\w+$', handler: rooms.delete);

  router.listen(port: port);
}
