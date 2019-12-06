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
      if (prefs.containsKey("service.api-gateway")) {
        try {
          http.Response response = await http.get("http://${prefs.getString("service.api-gateway")}:4000/");

          if (response.statusCode != 200) throw StatusCodeError(code: response.statusCode);

          Map map = json.decode(response.body);

          if (!map.containsKey("name") || map["name"] != "service.api-gateway") throw ResponseError();

          Navigator.of(context).pushReplacementNamed("/home");
        } catch (error) {
          // API Gateway could not be reached and an error was thrown...
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
    return Container(color: Theme.of(context).scaffoldBackgroundColor);
  }
}
