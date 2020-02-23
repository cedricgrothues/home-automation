import 'dart:io';

/// This class defines a device, discovered either by SSDP or ip search.
class Device {
  const Device({this.location});

  /// The server's location, e.g. http://192.182.1.2:4004/.
  final InternetAddress location;
}
