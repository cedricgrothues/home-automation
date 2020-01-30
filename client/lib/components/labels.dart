import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoColors;

import 'package:home/network/models/device.dart';

/// The [StateLabel] class defines a `Text` that holds device information,
/// like the `power` and `brightness`state.
class StateLabel extends StatelessWidget {
  const StateLabel({Key key, @required this.device, @required this.style, this.long = false})
      : assert(device != null),
        assert(style != null),
        super(key: key);

  final Device device;
  final TextStyle style;
  final bool long;

  @override
  Widget build(BuildContext context) {
    if (device.state.error) {
      return Text(
        'No Response',
        style: style.copyWith(color: CupertinoColors.destructiveRed),
        maxLines: 1,
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
      );
    } else if (!device.state.power) {
      return Text(
        'Off',
        style: style,
        maxLines: 1,
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
      );
    } else if (device.state.power) {
      return Text(
        device.state.brightness != null ? "${device.state.brightness.value} %${long ? " Brightness" : ""}" : 'On',
        style: style,
        maxLines: 1,
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
      );
    }

    return Text(
      '...',
      style: style,
      maxLines: 1,
      textAlign: TextAlign.start,
      overflow: TextOverflow.ellipsis,
    );
  }
}
