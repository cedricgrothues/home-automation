import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:home/src/network/models/device.dart';
import 'package:home/src/widgets/device.dart';

class DeviceControl extends StatefulWidget {
  const DeviceControl({Key key, @required this.devices}) : super(key: key);

  final Future<List<Device>> devices;

  @override
  _DeviceControlState createState() => _DeviceControlState();
}

class _DeviceControlState extends State<DeviceControl> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        FutureBuilder<List<Device>>(
          future: widget.devices,
          builder: (context, snapshot) {
            final cards = snapshot.data
                .map((device) => DeviceCard(device, key: Key(device.id)))
                .toList();

            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 140.0,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 1.0,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => cards[index],
                  childCount: cards.length,
                ),
              ),
            );
          },
          initialData: const [],
        ),
      ],
    );
  }
}
