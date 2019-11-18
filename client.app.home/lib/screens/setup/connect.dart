import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:home/components/regular_icons.dart';
import 'package:home/services/scanner.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Connect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureProvider<InternetAddress>.value(
        value: discover(),
        child: ConnectResult(),
      ),
    );
  }

  Future<InternetAddress> discover() async {
    final String ip = await Connectivity().getWifiIP();
    final String subnet = ip.substring(0, ip.lastIndexOf('.'));

    /// Default device registry port (change if necessary)
    final int port = 4000;

    final Stream<NetworkAddress> stream = NetworkAnalyzer.discover(subnet, port, timeout: Duration(milliseconds: 200));
    await for (NetworkAddress addr in stream) {
      if (addr == null || !addr.exists) continue;

      http.Response response = await http.get("http://${addr.address}:$port/");

      if (response.statusCode != 200) continue;

      Map map = json.decode(response.body);

      if (!map.containsKey("name") || map["name"] != "service.device-registry") continue;

      return InternetAddress(addr.address);
    }

    return null;
  }
}

class ConnectResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Provider.of<InternetAddress>(context) != null) {
      store(context, address: Provider.of<InternetAddress>(context).address)
          .then((ok) => Navigator.of(context).pushReplacementNamed("/rooms"));
    }

    return Scaffold(
      body: Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }

  Future<bool> store(BuildContext context, {String address}) {
    return Provider.of<SharedPreferences>(context).setString('service.device-registry', address);
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
                    "Enter the Device Registry's IP Address",
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
