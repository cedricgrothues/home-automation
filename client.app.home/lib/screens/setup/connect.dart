import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:home/components/icons.dart';
import 'package:home/services/scanner.dart';

class Connect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<InternetAddress>>(
          future: discover(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return LinearProgressIndicator(
                  value: 1,
                );
              case ConnectionState.done:
                if (snapshot.hasError)
                  return Text('Error: ${snapshot.error}');
                else if (snapshot.hasData)
                  return Text('IP: ${snapshot.data.first.address}');
                else
                  return Text('Result without Data');
            }
            return null; // unreachable
          },
        ),
      ),
    );
  }

  Future<List<InternetAddress>> discover() async {
    List<InternetAddress> addresses = [];

    final String ip = await Connectivity().getWifiIP();
    final String subnet = ip.substring(0, ip.lastIndexOf('.'));

    /// Default device registry port (change if necessary)
    final int port = 5000;

    final Stream<NetworkAddress> stream = NetworkAnalyzer.discover(subnet, port, timeout: Duration(milliseconds: 200));
    final stopwatch = Stopwatch()..start();
    await for (NetworkAddress addr in stream) {
      if (addr != null && addr.exists) {
        addresses.add(InternetAddress(addr.address));
        print(addr.address);
      }
    }
    print(stopwatch.elapsed);
    return addresses;
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
          icon: Icon(LightIcons.times),
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
