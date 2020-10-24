import 'dart:io';

/// A [Device] that's discoverable by SSDP or IP search
class Device {
  const Device({this.location});

  /// [Device] IP address and port, e.g. http://192.182.1.2:4004/.
  final InternetAddress location;
}
