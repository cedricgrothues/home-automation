import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:home/network/models/device.dart';

class DeviceService {
  static Future<List<Device>> fetch() async {
    String gateway = (await SharedPreferences.getInstance())
        .getString("service.api-gateway");

    Response response =
        await get("http://$gateway:4000/service.device-registry/devices");

    if (response.statusCode != 200) return [];

    List<dynamic> devices = json.decode(response.body) ?? [];

    for (Map<String, dynamic> device in devices) {
      if (!(device.containsKey("controller") && device.containsKey("id")))
        continue;

      try {
        Response response = await get(
            "http://$gateway:4000/${device['controller']}/devices/${device['id']}");
        device.putIfAbsent(
            "state",
            () =>
                json.decode(response.body)["state"] ??
                {"error": "not available"});
      } catch (error) {
        device.putIfAbsent("state", () => {"error": "not available"});
      }
    }

    return devices != null
        ? devices
            .map((dynamic device) => Device.fromJson(Map.from(device)))
            .toList()
        : [];
  }

  static Future<Map<String, dynamic>> update({Device device}) async {
    String gateaway = (await SharedPreferences.getInstance())
        .getString("service.api-gateway");

    try {
      Response result = await patch(
        "http://$gateaway:4000/${device.controller}/devices/${device.id}",
        body: json.encode({"power": !device.state["power"]}),
      );

      if (result.statusCode != 200) return {"error": "failed to reload"};

      Map decoded = json.decode(result.body);

      if (!decoded.containsKey("state"))
        return {"error": "state not available"};

      return decoded["state"];
    } catch (error) {
      return {"error": "$error"};
    }
  }

  static Future<Map<String, dynamic>> refresh({Device device}) async {
    String gateaway = (await SharedPreferences.getInstance())
        .getString("service.api-gateway");

    try {
      Response result = await get(
          "http://$gateaway:4000/${device.controller}/devices/${device.id}");

      if (result.statusCode != 200) return {"error": "failed to reload"};

      Map decoded = json.decode(result.body);

      if (!decoded.containsKey("state"))
        return {"error": "state not available"};

      return decoded["state"];
    } catch (error) {
      return {"error": "$error"};
    }
  }
}
