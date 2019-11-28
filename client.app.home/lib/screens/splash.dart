import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
      if (prefs.containsKey("service.device-registry")) {
        try {
          http.Response response = await http.get("http://${prefs.getString("service.device-registry")}:4000/");

          if (response.statusCode != 200) throw StatusCodeError(code: response.statusCode);

          Map map = json.decode(response.body);

          if (!map.containsKey("name") || map["name"] != "service.device-registry") throw ResponseError();

          Navigator.of(context).pushReplacementNamed("/home");
        } catch (error) {
          // Device registry could not be reached and an error was thrown...
          Navigator.of(context).pushReplacementNamed("/connection_failed");
          print(error);
        }
      } else
        Navigator.of(context).pushReplacementNamed("/setup");
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.white);
  }
}
