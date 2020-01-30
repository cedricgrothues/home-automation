import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;

import 'package:home/services/ssdp.dart';

import 'package:pedantic/pedantic.dart' show unawaited;

class Discover extends StatefulWidget {
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((Duration duration) async {
      try {
        /// if the search was successfull, Discover
        /// automatically redirects the user to `redirect`,
        discover(context, target: ModalRoute.of(context).settings.arguments as String, success: (String address) {});
      } on SocketException {
        // SocketException are thrown if there was a problem with binding to the socket.

        unawaited(Navigator.of(context).pushReplacementNamed('/connection_failed'));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CupertinoActivityIndicator(
          radius: 12,
        ),
      ),
    );
  }
}
