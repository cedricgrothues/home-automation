import 'dart:async' show TimeoutException;
import 'dart:io' show SocketException, Platform, Directory;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pedantic/pedantic.dart' show unawaited;

import 'package:home/src/models/errors.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    // Add the status() function as post frame callback
    // so it's called after _SplashState's initial build.
    WidgetsBinding.instance.addPostFrameCallback((_) => status());
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: Theme.of(context).scaffoldBackgroundColor);
  }

  /// The status function checks the connection to the API Gateway service and redirects
  /// the user to the correct screen.
  ///
  /// Don't call this function during build.
  Future<void> status() async {
    if (!kIsWeb) {
      Hive.init(Platform.isMacOS
          ? Directory.current.path
          : (await getApplicationDocumentsDirectory()).path);
    }

    final box = await Hive.openBox<String>('preferences');

    if (!box.containsKey('username')) {
      // The API gateway might be available, but the user has not
      // yet chosen a username and/or profile picture, so we'll
      // redirect them to the account setup page
      unawaited(Navigator.of(context).pushReplacementNamed('/setup'));
      return;
    }

    try {
      final response = await get('http://hub.local:4000/').timeout(
        const Duration(seconds: 2),
      );

      // Here we won't accept any status code that is not `200` / http.StatusOK since we know
      // that this is the possible status code the server will return this if the response was successfull.
      if (response.statusCode != 200) throw ResponseException();

      // Don't accept any other status codes than OK.
      if (!response.body.contains('core.api-gateway')) {
        throw ResponseException();
      }

      // The API gateway is available and the user finished the setup process
      // so we'll redirect the user to the home page.
      unawaited(Navigator.of(context).pushReplacementNamed('/home'));
    } on SocketException catch (error) {
      // SocketExceptions are thrown if there appears to be a problem with the users internet connection
      // or if a DNS lookup failed (latter should not be a problem at this point sice we're working with ip addresses instead of urls)

      unawaited(Navigator.of(context)
          .pushReplacementNamed('/connection_failed', arguments: error));
    } on TimeoutException catch (error) {
      // The timeout exception is thrown, if there was no server response after 1 second to minimize initial loading time.
      // Since the server is most likely running on a local network, we'll just assume that it is unreachable.

      unawaited(Navigator.of(context)
          .pushReplacementNamed('/connection_failed', arguments: error));
    } on ResponseException catch (error) {
      // A ResponseException is thrown if either the status code is not http.StatusOK or
      // if the response we got from the server did not contain the right keys / values
      // (In this case it's the service's identifier that should be contained in the response)

      unawaited(Navigator.of(context)
          .pushReplacementNamed('/connection_failed', arguments: error));
    } catch (error) {
      // We could neither catch a SocketException nor the TimeoutException that is thrown after 1 second.
      // I am not particularly sure if there is any other error that could be thrown here,
      // but if for some reason that happens, we'll just log it and show the error screen.

      print('Unhandled Exception $error of type: ${error.runtimeType}');

      unawaited(Navigator.of(context)
          .pushReplacementNamed('/connection_failed', arguments: error));
    }
  }
}
