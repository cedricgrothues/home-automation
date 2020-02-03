import 'dart:async' show TimeoutException;
import 'dart:io' show SocketException;

import 'package:http/http.dart' show get;

import 'package:home/network/models/device.dart' show Device;
import 'package:home/models/errors.dart' show ResponseException;

/// The [RegistryService] handles all requests regarding core.device-registry
class RegistryService {
  /// Exists checks wheter the given address exists within the
  /// scope of the controller (if not null) or the entire device-registry
  static Future<bool> exists(String address, {String controller = ''}) async {
    if (controller != '') controller = '?controller=' + controller;

    try {
      final response = await get('http://hub.local:4000/core.device-registry/devices$controller').timeout(
        const Duration(seconds: 1),
      );

      if (response.statusCode < 200 || response.statusCode > 299) throw ResponseException();

      if (response.body.contains(address)) {
        return true;
      } else {
        return false;
      }
    } on SocketException {
      // SocketExceptions are thrown if there appears to be a problem with the users internet connection
      // or if a DNS lookup failed (latter should not be a problem at this point sice we're working with ip addresses instead of urls)

      return true;
    } on ResponseException {
      // A ResponseException is thrown if either the status code is not between 200 and 299 or
      // if the response we got from the server did not contain the right keys / values

      return true;
    } on TimeoutException {
      // The timeout exception is thrown, if there was no server response after 1 second to minimize initial loading time.
      // Since the server is most definitely running on a local network, we'll just assume that it is unreachable.

      return true;
    } catch (error) {
      // We could neither catch a SocketException nor the TimeoutException that is thrown after 1 second.
      // I am not particularly sure if there is any other error that could be thrown here,
      // but if for some reason that happens, we'll just log it.

      print('Unhandled Exception $error of type: ${error.runtimeType}');

      return true;
    }
  }

  static Future<void> remove(String id) async {
    throw UnimplementedError();
  }

  static Future<void> add(Device device) async {
    throw UnimplementedError();
  }
}
