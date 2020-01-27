import 'package:flutter/material.dart';

import 'package:connectivity/connectivity.dart' show Connectivity, ConnectivityResult;

import 'package:home/components/icons.dart';

/// NetworkAware: This widget renders a `NoWifi()` screen above the current `child`
/// if it detects a state change from the `ConnectivityResult Provider` defined in main.dart's
/// `MultiProvider` Widget. If this provider is not present, the widgit will throw an exception.
class NetworkAware extends StatelessWidget {
  const NetworkAware({Key key, @required this.child}) : super(key: key);

  final Widget child;

  static final Stream<ConnectivityResult> stream = Connectivity().onConnectivityChanged;

  @override
  Widget build(BuildContext context) {
    /// Register a StreamBuilder that listens to the connectivity result
    /// changes. This is used to show a `NoWifi` page, if wifi is
    /// not availiable. Register all other global providers here.
    return StreamBuilder<ConnectivityResult>(
      stream: stream,
      initialData: ConnectivityResult.wifi,
      builder: (context, snapshot) {
        return Stack(
          children: <Widget>[
            child,
            if (snapshot.data != ConnectivityResult.wifi) NoWifi(),
          ],
        );
      },
    );
  }
}

/// This class defines the widget that is rendered above NetworkAware's current child.
/// See `NetworkAware` for more information on this.
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
                LightIcons.wifi_slash,
                size: 40,
                color: Theme.of(context).buttonColor.withOpacity(0.2),
              ),
              SizedBox(height: 60),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 80),
                constraints: BoxConstraints(
                  minWidth: 200,
                  maxWidth: 300,
                ),
                child: Text(
                  "You need to be connected to a wireless network to use the Home App. Go to Settings > Wi-Fi on your device.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle
                      .copyWith(height: 2, fontWeight: FontWeight.w400, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
