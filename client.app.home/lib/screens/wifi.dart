import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:home/components/regular_icons.dart';

class NetworkAware extends StatelessWidget {
  const NetworkAware({Key key, @required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 200),
      child: Provider.of<ConnectivityResult>(context) == ConnectivityResult.wifi ? child : NoWifi(),
    );
  }
}

class NoWifi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                RegularIcons.wifi_slash,
                size: 40,
                color: Theme.of(context).buttonColor,
              ),
              SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: Text(
                  "You need to be connected to a wireless network to use the Home App. Go to Settings > Wi-Fi on your device.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle.copyWith(height: 2, fontWeight: FontWeight.w400, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}