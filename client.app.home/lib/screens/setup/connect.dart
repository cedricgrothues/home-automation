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
                Image.asset(
                  "assets/images/logo.png",
                  height: 15,
                  fit: BoxFit.cover,
                  color: Theme.of(context).canvasColor,
                ),
                SizedBox(width: 10),
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
