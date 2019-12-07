import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import 'package:home/widgets/device.dart';
import 'package:home/network/models/device.dart';

class Devices extends StatefulWidget {
  @override
  _DevicesState createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  @override
  Widget build(BuildContext context) {
    List<Device> devices = Provider.of<List<Device>>(context);

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      direction: Axis.horizontal,
      children: devices != null ? devices.map((device) => DeviceCard(device)).toList() : [],
    );
  }
}
