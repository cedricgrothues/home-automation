import 'dart:io';
import 'dart:convert' show utf8;

import 'package:flutter/material.dart' show BuildContext, required;

final InternetAddress multicast = InternetAddress('239.255.255.250');

/// Quick discover all devices ssdp devices that comply with the specified `target`.
///
/// [target] may not be null. May throw
void discover(BuildContext context,
    {String target = 'ssdp:all', @required void Function(String address) success}) async {
  RawDatagramSocket socket;

  try {
    socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
  } on SocketException catch (error) {
    // An error occured while trying to bind the socket.
    // Forwarding the error.

    print('Failed to join ipv4 multicast group: $error');

    rethrow;
  }

  socket.broadcastEnabled = true;
  socket.readEventsEnabled = true;
  socket.multicastHops = 50;

  try {
    socket.joinMulticast(multicast);
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
    socket.send(data, multicast, 1900);
  } on SocketException catch (error) {
    print('Failed to send data to multicast group: $error');
  }

  socket.listen((event) {
    switch (event) {
      case RawSocketEvent.read:
        final packet = socket.receive();
        socket.writeEventsEnabled = true;
        socket.readEventsEnabled = true;

        if (packet == null) return;

        final data = utf8.decode(packet.data);
        final parts = data.split('\r\n');
        parts.removeWhere((x) => x.trim().isEmpty);

        final fl = parts.removeAt(0);

        if ((fl.toLowerCase().trim() == 'HTTP/1.1 200 OK'.toLowerCase()) ||
            (fl.toLowerCase().trim() == 'NOTIFY * HTTP/1.1'.toLowerCase())) {
          final headers = {dynamic} as Map<String, dynamic>;

          for (final part in parts) {
            final hp = part.split(':');

            final name = hp[0].trim();
            final value = (hp..removeAt(0)).join(':').trim();

            headers[name.toUpperCase()] = value;
          }

          if (!headers.containsKey('LOCATION')) return;

          success(headers['LOCATION'] as String);
          socket.close();
          return;
        }

        break;
      case RawSocketEvent.write:
        break;
    }
  });
}
