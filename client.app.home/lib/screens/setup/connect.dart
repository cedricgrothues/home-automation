import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;

import 'package:hive/hive.dart';
import 'package:home/models/errors.dart';

import 'package:home/services/scanner.dart' show discover;

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
        String gateway = await discover();

        // discover() did not throw an Exception, so we can assume that
        // `gateway` contains service.api-gateway's ip address and is not null
        Hive.box('preferences').put('service.api-gateway', gateway);

        Navigator.of(context).pushReplacementNamed("/account_setup");
      } on NotFoundException {
        // NotFoundExceptions are thrown if `service.api-gateway` was not found
        // with in the device's subnet.

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
