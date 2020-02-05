import 'dart:async' show TimeoutException;
import 'dart:convert' show json;
import 'dart:io' show SocketException;

import 'package:http/http.dart';

import 'package:home/models/errors.dart';
import 'package:home/network/models/state.dart';
import 'package:home/network/models/device.dart';

/// The [DeviceService] handles all requests regarding a
/// [Device]'s state, such as refreshing, fetching and updating
class DeviceService {
  /// fetch is called when first loading the [Home] screen
  /// This method will return the inital list of devices and
  /// should not be called afterwards, except if the screen
  /// needs to be refreshed.
  static Future<List<Device>> fetch() async {
    print('refreshed');
    var devices = <Map<String, dynamic>>[];

    try {
      final response = await get('http://hub.local:4000/core.device-registry/devices').timeout(
        const Duration(seconds: 1),
      );

      if (response.statusCode < 200 || response.statusCode > 299) throw ResponseException();

      devices = List.castFrom<dynamic, Map<String, dynamic>>(
        json.decode(response.body) as List ?? <dynamic>[],
      );
    } on SocketException {
      // SocketExceptions are thrown if there appears to be a problem with the users internet connection
      // or if a DNS lookup failed (latter should not be a problem at this point sice we're working with ip addresses instead of urls)

      return <Device>[];
    } on ResponseException {
      // A ResponseException is thrown if either the status code is not between 200 and 299 or
      // if the response we got from the server did not contain the right keys / values

      return <Device>[];
    } on TimeoutException {
      // The timeout exception is thrown, if there was no server response after 1 second to minimize initial loading time.
      // Since the server is most definitely running on a local network, we'll just assume that it is unreachable.

      return <Device>[];
    } catch (error) {
      // We could neither catch a SocketException nor the TimeoutException that is thrown after 1 second.
      // I am not particularly sure if there is any other error that could be thrown here,
      // but if for some reason that happens, we'll just log it.

      print('Unhandled Exception $error of type: ${error.runtimeType}');

      return <Device>[];
    }

    for (final device in devices) {
      if (!device.containsKey('controller') || !device.containsKey('id')) continue;

      try {
        final response = await get("http://hub.local:4000/${device['controller']}/devices/${device['id']}").timeout(
          const Duration(seconds: 1),
        );

        if (response.statusCode < 200 || response.statusCode > 299) throw ResponseException();

        device['state'] = json.decode(response.body)['state'] ?? {'error': true};
      } on SocketException {
        // SocketExceptions are thrown if there appears to be a problem with the users internet connection
        // or if a DNS lookup failed (latter should not be a problem at this point sice we're working with ip addresses instead of urls)

        device['state'] = {'error': true};
      } on ResponseException {
        // A ResponseException is thrown if either the status code is not between 200 and 299 or
        // if the response we got from the server did not contain the right keys / values

        device['state'] = {'error': true};
      } on TimeoutException {
        // The timeout exception is thrown, if there was no server response after 1 second to minimize initial loading time.
        // Since the server is most definitely running on a local network, we'll just assume that it is unreachable.

        device['state'] = {'error': true};
      } catch (error) {
        // We could neither catch a SocketException nor the TimeoutException that is thrown after 1 second.
        // I am not particularly sure if there is any other error that could be thrown here,
        // but if for some reason that happens, we'll just log it.

        print('Unhandled Exception $error of type: ${error.runtimeType}');

        device['state'] = {'error': true};
      }
    }

    return devices != null ? devices.map((device) => Device.fromJson(device)).toList() : <Device>[];
  }

  /// update alters the device state, based on the passed instance
  /// of [Device]. It's called when pressing a device card and returns
  /// the updated device instance.
  static Future<DeviceState> update({Device device}) async {
    try {
      final result = await put(
        'http://hub.local:4000/${device.controller}/devices/${device.id}',
        body: json.encode({'power': !device.state.power}),
      ).timeout(
        const Duration(seconds: 1),
      );

      if (result.statusCode < 200 || result.statusCode > 299) throw ResponseException();

      final response = await get('http://hub.local:4000/${device.controller}/devices/${device.id}').timeout(
        const Duration(seconds: 1),
      );

      final decoded = json.decode(response.body) as Map<String, dynamic>;

      if (result.statusCode < 200 || result.statusCode > 299 || !decoded.containsKey('state')) {
        throw ResponseException();
      }

      return DeviceState.fromJson(decoded['state'] as Map<String, dynamic>);
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

      print('Unhandled Exception $error of type: ${error.runtimeType}');

      return DeviceState(error: true);
    }
  }

  /// Refresh does virtually the same as update, with the diffrence
  /// that it won't alter the device state, but instead just return
  /// an updated instance. This is used to rebuild the screen if the
  /// [DeviceState] changes.
  static Future<DeviceState> refresh({Device device}) async {
    try {
      final response = await get('http://hub.local:4000/${device.controller}/devices/${device.id}').timeout(
        const Duration(seconds: 2),
      );

      if (response.statusCode < 200 || response.statusCode > 299) throw ResponseException();

      final decoded = json.decode(response.body) as Map<String, dynamic>;

      if (!decoded.containsKey('state')) throw ResponseException();

      return DeviceState.fromJson(decoded['state'] as Map<String, dynamic>);
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

      print('Unhandled Exception $error of type: ${error.runtimeType}');

      return DeviceState(error: true);
    }
  }
}
