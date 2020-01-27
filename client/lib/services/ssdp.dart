import 'dart:io';
import 'dart:async' show StreamController;
import 'dart:convert' show utf8;

class SSDP {
  List<RawDatagramSocket> _sockets = <RawDatagramSocket>[];
  StreamController<String> _controller = StreamController.broadcast();

  List<NetworkInterface> _interfaces;

  static final InternetAddress multicast = InternetAddress("239.255.255.250");

  /// List all [NetworkInterface] and listens on all IPv4 multicast addresses
  Future<void> start() async {
    _interfaces = await NetworkInterface.list();

    await _create(InternetAddress.anyIPv4);
  }

  /// Creates a new [RawDatagramSocket] and listens on the [multicast] address
  Future<void> _create(InternetAddress address) async {
    RawDatagramSocket socket = await RawDatagramSocket.bind(address, 0);

    socket.broadcastEnabled = true;
    socket.readEventsEnabled = true;
    socket.multicastHops = 50;

    socket.listen((event) {
      switch (event) {
        case RawSocketEvent.read:
          Datagram packet = socket.receive();
          socket.writeEventsEnabled = true;
          socket.readEventsEnabled = true;

          if (packet == null) return;

          String data = utf8.decode(packet.data);

          List<String> parts = data.split("\r\n");
          parts.removeWhere((x) => x.trim().isEmpty);

          String fl = parts.removeAt(0);

          if ((fl.toLowerCase().trim() == "HTTP/1.1 200 OK".toLowerCase()) ||
              (fl.toLowerCase().trim() == "NOTIFY * HTTP/1.1".toLowerCase())) {
            Map<String, String> headers = {};

            for (String part in parts) {
              List<String> hp = part.split(":");

              String name = hp[0].trim();
              String value = (hp..removeAt(0)).join(":").trim();

              headers[name.toUpperCase()] = value;
            }

            if (!headers.containsKey("LOCATION")) return;

            _controller.add(headers["LOCATION"]);
          }

          break;
        case RawSocketEvent.write:
          break;
      }
    });

    try {
      socket.joinMulticast(multicast);
    } on OSError catch (error) {
      // An error occured while trying to join the
      // multicast group

      print("Failed to join ipv4 multicast group: $error");
    }

    for (NetworkInterface interface in _interfaces) {
      try {
        socket.joinMulticast(multicast, interface);
      } on OSError catch (error) {
        // An error occured while trying to join the
        // multicast group

        print("Failed to join ipv4 multicast group: $error");
      }
    }

    _sockets.add(socket);
  }

  /// Close all [RawDatagramSockets] and the [StreamController]
  void stop() {
    for (RawDatagramSocket socket in _sockets) socket.close();

    if (!_controller.isClosed) {
      _controller.close();
      _controller = StreamController<String>.broadcast();
    }
  }

  /// A [Stream] of all client addresses discovered
  Stream<String> get clients => _controller.stream;

  /// Search for a specific ssdp target.
  /// Defaults to `ssdp:all`.
  void search({String target = "ssdp:all"}) {
    StringBuffer buff = StringBuffer();

    buff.write("M-SEARCH * HTTP/1.1\r\n");
    buff.write("HOST: 239.255.255.250:1900\r\n");
    buff.write('MAN: "ssdp:discover"\r\n');
    buff.write("MX: 1\r\n");
    buff.write("ST: $target\r\n");
    buff.write("USER-AGENT: unix/5.1 UPnP/1.1 crash/1.0\r\n\r\n");

    List<int> data = utf8.encode(buff.toString());

    for (RawDatagramSocket socket in _sockets) {
      if (socket.address.type != multicast.type) continue;

      try {
        socket.send(data, multicast, 1900);
      } on SocketException {}
    }
  }

  /// Quick discover all devices ssdp devices that comply with the specified `query`.
  ///
  /// [timeout], [query], and [unique] may not be null.
  Stream<String> discover({
    Duration timeout: const Duration(seconds: 3),
    String query = "ssdp:all",
    bool unique: true,
  }) async* {
    assert(timeout != null);
    assert(unique != null);
    assert(query != null);

    if (_sockets.isEmpty) await start();

    Set seen = Set<String>();

    search(target: query);
    Future.delayed(timeout, () => stop());

    await for (String client in clients) {
      if (unique && seen.contains(client)) continue;

      seen.add(client);
      yield client;
    }
  }
}
