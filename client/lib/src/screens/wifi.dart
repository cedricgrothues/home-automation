import 'package:flutter/material.dart';

import 'package:connectivity/connectivity.dart' show Connectivity, ConnectivityResult;

/// [NetworkAware] renders a `NoWifi()` screen above the current `child` if
/// it detects a `ConnectivityResult` state change.
class NetworkAware extends StatelessWidget {
  const NetworkAware({Key key, @required this.child}) : super(key: key);

  final Widget child;

  static final Stream<ConnectivityResult> stream = Connectivity().onConnectivityChanged;

  @override
  Widget build(BuildContext context) {
    /// Register a [StreamBuilder] that listens to [ConnectivityResult]
    /// changes. This is used to show a `NoWifi` page, if the user is not
    /// connected to wifi.
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

/// [NoWifi] is rendered above NetworkAware's current child.
/// See [NetworkAware] for more information on this widget.
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
                Icons.filter_drama,
                size: 100,
                color: Theme.of(context).buttonColor.withOpacity(0.2),
              ),
              const SizedBox(height: 60),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 80),
                constraints: const BoxConstraints(
                  minWidth: 200,
                  maxWidth: 300,
                ),
                child: Text(
                  'You need to be connected to a wireless network to use the Home App. Go to Settings > Wi-Fi on your device.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
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
