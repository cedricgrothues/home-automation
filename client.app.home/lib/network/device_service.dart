import 'dart:convert' show json;

import 'package:hive/hive.dart';
import 'package:http/http.dart';

import 'package:home/network/models/state.dart';
import 'package:home/network/models/device.dart';

class DeviceService {
  static Future<List<Device>> fetch() async {
    String gateway = Hive.box<String>('preferences').get('service.api-gateway');

    Response response = await get("http://$gateway:4000/service.device-registry/devices");

    if (response.statusCode < 200 || response.statusCode > 299) return [];

    List<dynamic> devices = json.decode(response.body) ?? [];

    for (Map<String, dynamic> device in devices) {
      if (!device.containsKey("controller") || !device.containsKey("id")) continue;

      try {
        Response response = await get("http://$gateway:4000/${device['controller']}/devices/${device['id']}");

        device["state"] = json.decode(response.body)["state"] ?? {"error": true};
      } catch (error) {
        device["state"] = {"error": true};
      }
    }

    return devices != null ? devices.map((dynamic device) => Device.fromJson(Map.from(device))).toList() : [];
  }

  static Future<DeviceState> update({Device device}) async {
    String gateway = Hive.box<String>('preferences').get('service.api-gateway');

    try {
      Response result = await put(
        "http://$gateway:4000/${device.controller}/devices/${device.id}",
        body: json.encode({"power": !device.state.power}),
      );

      if (result.statusCode < 200 || result.statusCode > 299) return DeviceState(error: true);

      Response response = await get("http://$gateway:4000/${device.controller}/devices/${device.id}");

      Map decoded = json.decode(response.body);

      if (!decoded.containsKey("state")) return DeviceState(error: true);

      return DeviceState.fromJson(decoded["state"]);
    } catch (error) {
      return DeviceState(error: true);
    }
  }

  static Future<DeviceState> refresh({Device device}) async {
    String gateway = Hive.box<String>('preferences').get('service.api-gateway');

    try {
      Response result = await get("http://$gateway:4000/${device.controller}/devices/${device.id}");

      if (result.statusCode < 200 || result.statusCode > 299) return DeviceState(error: true);

      Map decoded = json.decode(result.body);

      if (!decoded.containsKey("state")) return DeviceState(error: true);

      return DeviceState.fromJson(decoded["state"]);
    } catch (error) {
      return DeviceState(error: true);
    }
  }
}
