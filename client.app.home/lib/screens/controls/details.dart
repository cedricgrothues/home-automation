import 'package:flutter/material.dart';
import 'package:home/network/models/device.dart';

/// Details is called on a long-press on a `DeviceCard`.
/// It shows detailed information on the device and
/// provides more in-depth control over the device.
class Details extends StatefulWidget {
  final Device device;

  const Details({Key key, @required this.device}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
    );
  }
}
