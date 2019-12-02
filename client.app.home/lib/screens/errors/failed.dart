import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:home/components/button.dart';
import 'package:home/components/light_icons.dart';

import 'package:home/models/errors.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
                child: Icon(
                  LightIcons.broadcast_tower,
                  size: 90,
                  color: Theme.of(context).iconTheme.color.withOpacity(0.2),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 70, horizontal: 70),
                    child: Text(
                      "We could not connect to your Home Hub. Please ensure it is plugged in, online and operational, then try again.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle.copyWith(height: 2, fontWeight: FontWeight.w400, fontSize: 15),
                    ),
                  ),
                  Button(
                    title: "Tap to try again",
                    onPressed: () async {
                      SharedPreferences prefs = Provider.of<SharedPreferences>(context);

                      if (prefs != null) {
                        if (prefs.containsKey("service.device-registry")) {
                          try {
                            http.Response response = await http.get("http://${prefs.getString("service.device-registry")}:4000/");

                            if (response.statusCode != 200) throw StatusCodeError(code: response.statusCode);

                            Map map = json.decode(response.body);

                            if (!map.containsKey("name") || map["name"] != "service.device-registry") throw ResponseError();

                            Navigator.of(context).pushReplacementNamed("/home");
                          } catch (error) {}
                        } else
                          Navigator.of(context).pushReplacementNamed("/connect");
                      }
                    },
                    width: MediaQuery.of(context).size.width - 150,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
