import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:home/components/regular_icons.dart';

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
        store(context, address: Provider.of<String>(context)).then((ok) => Navigator.of(context).pushReplacementNamed("/home"));
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

  Future<bool> store(BuildContext context, {String address}) {
    return Provider.of<SharedPreferences>(context).setString('service.api-gateway', address);
  }
}

class ManualConnect extends StatelessWidget {
  static TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(RegularIcons.times),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 150,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Text(
                    "Enter your Home Hub's IP Address",
                    style: Theme.of(context).textTheme.body1,
                  ),
                ),
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  style: Theme.of(context).textTheme.body1,
                  decoration: InputDecoration(
                    hintText: "127.0.0.1",
                    hintStyle: Theme.of(context).textTheme.body1.copyWith(color: Colors.black45),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black45),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
            height: 60,
            child: CupertinoButton(
              padding: EdgeInsets.all(0),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Theme.of(context).buttonColor,
                alignment: Alignment.center,
                child: Text(
                  "Connect",
                  style: Theme.of(context).textTheme.button.copyWith(fontSize: 16),
                ),
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
