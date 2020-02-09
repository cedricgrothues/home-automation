import 'dart:async' show TimeoutException;
import 'dart:convert' show json;
import 'dart:io' show SocketException;

import 'package:http/http.dart';

import 'package:home/models/errors.dart';
import 'package:home/network/models/scene.dart';

/// The [DeviceService] handles all requests regarding a
/// [Device]'s state, such as refreshing, fetching and updating
class SceneService {
  /// fetch is called when first loading the [Home] screen
  /// This method will return the inital list of devices and
  /// should not be called afterwards, except if the screen
  /// needs to be refreshed.
  static Future<List<Scene>> fetch() async {
    var scenes = <Map<String, dynamic>>[];

    try {
      final response = await get('http://hub.local:4000/modules.scene/scenes').timeout(
        const Duration(seconds: 1),
      );

      if (response.statusCode < 200 || response.statusCode > 299) throw ResponseException();

      scenes = List.castFrom<dynamic, Map<String, dynamic>>(
        json.decode(response.body) as List ?? <dynamic>[],
      );
    } on SocketException {
      // SocketExceptions are thrown if there appears to be a problem with the users internet connection
      // or if a DNS lookup failed (latter should not be a problem at this point sice we're working with ip addresses instead of urls)

      return <Scene>[];
    } on ResponseException {
      // A ResponseException is thrown if either the status code is not between 200 and 299 or
      // if the response we got from the server did not contain the right keys / values

      return <Scene>[];
    } on TimeoutException {
      // The timeout exception is thrown, if there was no server response after 1 second to minimize initial loading time.
      // Since the server is most definitely running on a local network, we'll just assume that it is unreachable.

      return <Scene>[];
    } catch (error) {
      // We could neither catch a SocketException nor the TimeoutException that is thrown after 1 second.
      // I am not particularly sure if there is any other error that could be thrown here,
      // but if for some reason that happens, we'll just log it.

      print('Unhandled Exception $error of type: ${error.runtimeType}');

      return <Scene>[];
    }

    return scenes != null ? scenes.map((scene) => Scene.fromJson(scene)).toList() : <Scene>[];
  }

  static void run(Scene scene) async {
    try {
      final result = await get('http://hub.local:4000/modules.scene/scenes/${scene.id}/run').timeout(
        const Duration(seconds: 1),
      );

      if (result.statusCode < 200 || result.statusCode > 299) throw ResponseException();
    } on SocketException {
      // SocketExceptions are thrown if there appears to be a problem with the users internet connection
      // or if a DNS lookup failed (latter should not be a problem at this point sice we're working with ip addresses instead of urls)

      print('SocketException');
    } on ResponseException {
      // A ResponseException is thrown if either the status code is not between 200 and 299 or
      // if the response we got from the server did not contain the right keys / values

      print('ResponseException');
    } on TimeoutException {
      // The timeout exception is thrown, if there was no server response after 1 second to minimize initial loading time.
      // Since the server is most definitely running on a local network, we'll just assume that it is unreachable.

      print('TimeoutException');
    } catch (error) {
      // We could neither catch a SocketException nor the TimeoutException that is thrown after 1 second.
      // I am not particularly sure if there is any other error that could be thrown here,
      // but if for some reason that happens, we'll just log it.

      print('Unhandled Exception $error of type: ${error.runtimeType}');
    }
  }
}
