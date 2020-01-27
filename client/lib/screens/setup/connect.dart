import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;

class Connect extends StatefulWidget {
  @override
  _ConnectState createState() => _ConnectState();
}

class _ConnectState extends State<Connect> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((Duration duration) async {
      try {
        InternetAddress.lookup("http://hub.local");

        // did not throw an Exception, so we can assume that
        // `gateway` contains core.api-gateway's ip address and is not null

        Navigator.of(context).pushReplacementNamed("/account_setup");
      } on SocketException {
        // SocketException are thrown if `hub.local` was not found
        // with in the device's network.

        Navigator.of(context).pushReplacementNamed("/connection_failed");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Center(
            child: CupertinoActivityIndicator(
              radius: 12,
            ),
          ),
          Positioned(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 15,
                    fit: BoxFit.cover,
                    color: Theme.of(context).canvasColor,
                  ),
                ),
                Text(
                  "HOME",
                  style: TextStyle(
                    color: Theme.of(context).canvasColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            bottom: MediaQuery.of(context).viewInsets.bottom + 50,
          )
        ],
      ),
    );
  }
}
