import 'package:flutter/material.dart';

import 'package:pedantic/pedantic.dart';

import 'package:home/src/services/ssdp.dart';
import 'package:home/src/components/routes.dart';
import 'package:home/src/network/registry_service.dart';
import 'package:home/src/screens/add/complete/select.dart';
import 'package:home/src/screens/add/complete/complete.dart';
import 'package:home/src/screens/add/complete/none_found.dart';

class Discover extends StatefulWidget {
  const Discover({Key key, @required this.target, @required this.controller})
      : assert(target != null),
        super(key: key);

  final String target;
  final String controller;

  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((Duration duration) async {
      final devices = <String>{};
      await for (final device in discover(target: widget.target)) {
        final address =
            (device.replaceFirst('http://', '').split(':') ?? []).first;

        if (await RegistryService.exists(address,
            controller: widget.controller)) continue;

        devices.add(address);
      }

      if (devices.isEmpty) {
        unawaited(Navigator.of(context).push(
          FadeTransitionRoute(child: NoneFound()),
        ));
      } else if (devices.length == 1) {
        unawaited(Navigator.of(context).push(
          FadeTransitionRoute(child: FinishDiscovery(address: devices.first)),
        ));
      } else {
        unawaited(Navigator.of(context).push(
          FadeTransitionRoute(child: SelectDevice(devices: devices)),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Spacer(flex: 4),
              Text(
                'Your app is looking for devices to connect...',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                  'This may take up to 10 seconds.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFa2acbe),
                  ),
                ),
              ),
              Spacer(flex: 8),
            ],
          ),
        ),
      ),
    );
  }
}
