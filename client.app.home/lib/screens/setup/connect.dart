import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        store(context, address: Provider.of<String>(context))
            .then((ok) => Navigator.of(context).pushReplacementNamed("/home"));
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

  Future<bool> store(BuildContext context, {String address}) async {
    return (await SharedPreferences.getInstance()).setString('service.api-gateway', address);
  }
}
