import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:home/screens/home/addons/devices.dart';

import 'package:home/network/models/device.dart';

class DeviceControl extends StatelessWidget {
  final Future<List<Device>> devices;

  const DeviceControl({Key key, @required this.devices}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                FutureBuilder<List<Device>>(
                  future: devices,
                  builder: (context, snapshot) => Devices(data: snapshot.data),
                  initialData: [],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
