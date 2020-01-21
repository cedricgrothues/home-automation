import 'dart:io' show SocketException;
import 'dart:async' show TimeoutException;
import 'dart:convert' show json;

import 'package:hive/hive.dart';
import 'package:http/http.dart';

import 'package:home/models/errors.dart';
import 'package:home/network/models/state.dart';
import 'package:home/network/models/device.dart';

class DeviceService {
  static Future<List<Device>> fetch() async {
    List<dynamic> devices = [];

    String gateway = Hive.box<String>('preferences').get('service.api-gateway');

    try {
      Response response = await get("http://$gateway:4000/service.device-registry/devices").timeout(
        const Duration(seconds: 1),
      );

      if (response.statusCode < 200 || response.statusCode > 299) throw ResponseException();

      devices = json.decode(response.body);
    } on SocketException {
      // SocketExceptions are thrown if there appears to be a problem with the users internet connection
      // or if a DNS lookup failed (latter should not be a problem at this point sice we're working with ip addresses instead of urls)

      return [];
    } on ResponseException {
      // A ResponseException is thrown if either the status code is not between 200 and 299 or
      // if the response we got from the server did not contain the right keys / values

      return [];
    } on TimeoutException {
      // The timeout exception is thrown, if there was no server response after 1 second to minimize initial loading time.
      // Since the server is most definitely running on a local network, we'll just assume that it is unreachable.

      return [];
    } catch (error) {
      // We could neither catch a SocketException nor the TimeoutException that is thrown after 1 second.
      // I am not particularly sure if there is any other error that could be thrown here,
      // but if for some reason that happens, we'll just log it.

      print("Unhandled Exception $error of type: ${error.runtimeType}");

      return [];
    }

    for (Map<String, dynamic> device in devices) {
      if (!device.containsKey("controller") || !device.containsKey("id")) continue;

      try {
        Response response = await get("http://$gateway:4000/${device['controller']}/devices/${device['id']}").timeout(
          const Duration(seconds: 1),
        );

        if (response.statusCode < 200 || response.statusCode > 299) throw ResponseException();

        device["state"] = json.decode(response.body)["state"] ?? {"error": true};
      } on SocketException {
        // SocketExceptions are thrown if there appears to be a problem with the users internet connection
        // or if a DNS lookup failed (latter should not be a problem at this point sice we're working with ip addresses instead of urls)

        device["state"] = {"error": true};
      } on ResponseException {
        // A ResponseException is thrown if either the status code is not between 200 and 299 or
        // if the response we got from the server did not contain the right keys / values

        device["state"] = {"error": true};
      } on TimeoutException {
        // The timeout exception is thrown, if there was no server response after 1 second to minimize initial loading time.
        // Since the server is most definitely running on a local network, we'll just assume that it is unreachable.

        device["state"] = {"error": true};
      } catch (error) {
        // We could neither catch a SocketException nor the TimeoutException that is thrown after 1 second.
        // I am not particularly sure if there is any other error that could be thrown here,
        // but if for some reason that happens, we'll just log it.

        print("Unhandled Exception $error of type: ${error.runtimeType}");

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
      ).timeout(
        const Duration(seconds: 1),
      );

      if (result.statusCode < 200 || result.statusCode > 299) throw ResponseException();

      Response response = await get("http://$gateway:4000/${device.controller}/devices/${device.id}").timeout(
        const Duration(seconds: 1),
      );

      Map decoded = json.decode(response.body);

      if (result.statusCode < 200 || result.statusCode > 299 || !decoded.containsKey("state"))
        throw ResponseException();

      return DeviceState.fromJson(decoded["state"]);
    } on SocketException {
      // SocketExceptions are thrown if there appears to be a problem with the users internet connection
      // or if a DNS lookup failed (latter should not be a problem at this point sice we're working with ip addresses instead of urls)

      return DeviceState(error: true);
    } on ResponseException {
      // A ResponseException is thrown if either the status code is not between 200 and 299 or
      // if the response we got from the server did not contain the right keys / values

      return DeviceState(error: true);
    } on TimeoutException {
      // The timeout exception is thrown, if there was no server response after 1 second to minimize initial loading time.
      // Since the server is most definitely running on a local network, we'll just assume that it is unreachable.

      return DeviceState(error: true);
    } catch (error) {
      // We could neither catch a SocketException nor the TimeoutException that is thrown after 1 second.
      // I am not particularly sure if there is any other error that could be thrown here,
      // but if for some reason that happens, we'll just log it.

      print("Unhandled Exception $error of type: ${error.runtimeType}");

      return DeviceState(error: true);
    }
  }

  static Future<DeviceState> refresh({Device device}) async {
    String gateway = Hive.box<String>('preferences').get('service.api-gateway');

    try {
      Response result = await get("http://$gateway:4000/${device.controller}/devices/${device.id}").timeout(
        const Duration(seconds: 2),
      );

      if (result.statusCode < 200 || result.statusCode > 299) throw ResponseException();

      Map decoded = json.decode(result.body);

      if (!decoded.containsKey("state")) throw ResponseException();

      return DeviceState.fromJson(decoded["state"]);
    } on SocketException {
      // SocketExceptions are thrown if there appears to be a problem with the users internet connection
      // or if a DNS lookup failed (latter should not be a problem at this point sice we're working with ip addresses instead of urls)

      return DeviceState(error: true);
    } on ResponseException {
      // A ResponseException is thrown if either the status code is not between 200 and 299 or
      // if the response we got from the server did not contain the right keys / values

      return DeviceState(error: true);
    } on TimeoutException {
      print("TIMEOUT");
      // The timeout exception is thrown, if there was no server response after 1 second to minimize initial loading time.
      // Since the server is most definitely running on a local network, we'll just assume that it is unreachable.

      return DeviceState(error: true);
    } catch (error) {
      // We could neither catch a SocketException nor the TimeoutException that is thrown after 1 second.
      // I am not particularly sure if there is any other error that could be thrown here,
      // but if for some reason that happens, we'll just log it.

      print("Unhandled Exception $error of type: ${error.runtimeType}");

      return DeviceState(error: true);
    }
  }
}
