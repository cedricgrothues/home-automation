import 'dart:io' show SocketException;
import 'dart:async' show TimeoutException;

import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:pedantic/pedantic.dart' show unawaited;

import 'package:home/models/errors.dart';
import 'package:home/components/button.dart';

/// [ConnectionFailed] is supposed to be shown if the spash screen can't
/// establish a connection to the home hub (Either due to a timeout, socket
/// or response exception).
class ConnectionFailed extends StatefulWidget {
  @override
  _ConnectionFailedState createState() => _ConnectionFailedState();
}

class _ConnectionFailedState extends State<ConnectionFailed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom + 30),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                  height: 120,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 70),
                    constraints: BoxConstraints(maxWidth: 300),
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Text(
                      'We could not connect to your Home Hub. Please ensure it is plugged in, online and operational, then try again.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(height: 2, fontWeight: FontWeight.w400, fontSize: 15),
                    ),
                  ),
                  TryAgain(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TryAgain extends StatelessWidget {
  final SnackBar snackbar = SnackBar(
    content: Text(
      'Failed to connect to the API Gateway service.',
      textAlign: TextAlign.center,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Button(
      title: 'Tap to try again',
      onPressed: () async {
        final box = Hive.box<String>('preferences');

        if (!box.containsKey('username')) {
          // While the api gateway is availiable, the user has not yet choosen a username and / or profile picture
          // so we'll redirect them to the account setup page
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

          // There is no need to decode the json response. Simply check if the response contains the service name.
          if (!response.body.contains('core.api-gateway')) throw ResponseException();

          // The api gateway is available and the user finished the setup process
          // so we'll redirect the user to their home page
          unawaited(Navigator.of(context).pushReplacementNamed('/home'));
        } on SocketException {
          // SocketExceptions are thrown if there appears to be a problem with the users internet connection
          // or if a DNS lookup failed (latter should not be a problem at this point sice we're working with ip addresses instead of urls)

          Scaffold.of(context).showSnackBar(snackbar);
        } on TimeoutException {
          // The timeout exception is thrown, if there was no server response after 200ms to minimize initial loading time.
          // Since the server is most likely running on a local network, we'll just assume that it is unreachable.

          Scaffold.of(context).showSnackBar(snackbar);
        } on ResponseException {
          // A ResponseException is thrown if either the status code is not http.StatusOK or
          // if the response we got from the server did not contain the right keys / values
          // (In this case it's the service's identifier that should be contained in the response)

          Scaffold.of(context).showSnackBar(snackbar);
        } catch (error) {
          // We could neither catch a SocketException nor the TimeoutException that is thrown after 200ms.
          // I am not particularly sure if there is any other error that could be thrown here,
          // but if for some reason that happens, we'll just log it and show the error screen.

          print('Unhandled Exception $error of type: ${error.runtimeType}');

          Scaffold.of(context).showSnackBar(snackbar);
        }
      },
      width: MediaQuery.of(context).size.width - 150,
    );
  }
}
