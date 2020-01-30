import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;

import 'package:pedantic/pedantic.dart' show unawaited;

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
        await InternetAddress.lookup('http://hub.local');

        // did not throw an Exception, so we can assume that
        // `gateway` contains core.api-gateway's ip address and is not null

        unawaited(Navigator.of(context).pushReplacementNamed('/account_setup'));
      } on SocketException {
        // SocketException are thrown if `hub.local` was not found
        // with in the device's network.

        unawaited(Navigator.of(context).pushReplacementNamed('/connection_failed'));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CupertinoActivityIndicator(
          radius: 12,
        ),
      ),
    );
  }
}
