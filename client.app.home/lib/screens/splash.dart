import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

import 'package:home/models/errors.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void didChangeDependencies() async {
    SharedPreferences prefs = Provider.of<SharedPreferences>(context);

    if (prefs != null) {
      if (prefs.containsKey("service.api-gateway")) {
        try {
          Response response =
              await get("http://${prefs.getString("service.api-gateway")}:4000/").timeout(const Duration(milliseconds: 200));

          if (response.statusCode != 200) throw StatusCodeError(code: response.statusCode);

          Map map = json.decode(response.body);

          if (!map.containsKey("name") || map["name"] != "service.api-gateway") throw ResponseError();

          Navigator.of(context).pushReplacementNamed("/home");
        } on SocketException {
          Navigator.of(context).pushReplacementNamed("/connection_failed", arguments: {"error": "socket"});
        } on TimeoutException {
          Navigator.of(context).pushReplacementNamed("/connection_failed", arguments: {"error": "timeout"});
        } catch (error) {
          // We could neither catch a SocketException nor the TimeoutException that is thrown after 200ms.
          // I am not particularly sure if there is any other error that could be thrown here,
          // but if for some reason that happens, we'll just log it and show the error screen.

          print("Unhandled Exception $error of type: ${error.runtimeType}");

          Navigator.of(context).pushReplacementNamed("/connection_failed");
        }
      } else
        Navigator.of(context).pushReplacementNamed("/setup");
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: Theme.of(context).scaffoldBackgroundColor);
  }
}
