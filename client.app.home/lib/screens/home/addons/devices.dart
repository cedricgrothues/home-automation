import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:home/widgets/device.dart';
import 'package:home/network/models/device.dart';

class Devices extends StatefulWidget {
  final List<Device> data;

  const Devices({Key key, @required this.data}) : super(key: key);

  @override
  _DevicesState createState() => _DevicesState();
}

class _DevicesState extends State<Devices> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      direction: Axis.horizontal,
      children: widget.data != null ? widget.data.map((device) => DeviceCard(device)).toList() : [],
    );
  }
}
