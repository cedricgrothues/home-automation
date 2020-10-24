import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:io';

import 'package:pedantic/pedantic.dart' show unawaited;

final InternetAddress multicast = InternetAddress('239.255.255.250');

/// Quickly discover all devices that match the specified `target`.
Stream<String> discover({String target = 'ssdp:all'}) async* {
  final _controller = StreamController<String>();

  RawDatagramSocket _socket;

  unawaited(Future<void>.delayed(const Duration(seconds: 5), () async {
    if (_controller != null) await _controller.close();
    if (_socket != null) _socket.close();
  }));

  try {
    _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
  } on SocketException catch (error) {
    // Unable to bind `InternetAddress.anyIPv4` to `_socket`.

    print('Failed to join ipv4 multicast group: $error');

    rethrow;
  }

  _socket.broadcastEnabled = true;
  _socket.readEventsEnabled = true;
  _socket.multicastHops = 50;

  try {
    _socket.joinMulticast(multicast);
  } on OSError catch (error) {
    // An error occured while trying to join the
    // multicast group

    print('Failed to join ipv4 multicast group: $error');
  }

  final buffer = StringBuffer();

  buffer.write('M-SEARCH * HTTP/1.1\r\n');
  buffer.write('HOST: 239.255.255.250:1900\r\n');
  buffer.write('MAN: "ssdp:discover"\r\n');
  buffer.write('MX: 1\r\n');
  buffer.write('ST: $target\r\n');
  buffer.write('USER-AGENT: unix/5.1 UPnP/1.1 crash/1.0\r\n\r\n');

  final data = utf8.encode(buffer.toString());

  try {
    _socket.send(data, multicast, 1900);
  } on SocketException catch (error) {
    print('Failed to send data to multicast group: $error');
  }

  final _seen = <String>{};

  _socket.listen((event) {
    switch (event) {
      case RawSocketEvent.read:
        final packet = _socket.receive();
        _socket.writeEventsEnabled = true;
        _socket.readEventsEnabled = true;

        if (packet == null) return;

        final data = utf8.decode(packet.data);
        final parts = data.split('\r\n');

        parts.removeWhere((x) => x.trim().isEmpty);

        if (parts.removeAt(0).toLowerCase().trim() == 'HTTP/1.1 200 OK'.toLowerCase()) {
          for (final part in parts) {
            if (part.toLowerCase().contains('location')) {
              final address = part.split(' ').last;

              if (_seen.contains(address)) continue;

              _controller.add(address);
              _seen.add(address);
            }
          }
        }

        break;
      default:
        break;
    }
  });

  await for (final client in _controller.stream) {
    yield client;
  }
}
