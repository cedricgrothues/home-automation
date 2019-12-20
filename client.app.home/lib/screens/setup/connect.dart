import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class Connect extends StatefulWidget {
  @override
  _ConnectState createState() => _ConnectState();
}

class _ConnectState extends State<Connect> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    String ip = Provider.of<String>(context);

    if (ip == null) return;

    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      if (ip != null && ip != "not_found") {
        Box<String> box = Hive.box('preferences');
        box.put('service.api-gateway', Provider.of<String>(context));
        Navigator.of(context).pushReplacementNamed("/account_setup");
      } else if (ip != null && ip == "not_found") {
        Navigator.of(context).pushReplacementNamed("/connection_failed");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CupertinoActivityIndicator(
              radius: 12,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Text(
                "Looking for a Home Hub...",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
    );
  }
}
