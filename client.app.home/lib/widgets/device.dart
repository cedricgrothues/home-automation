import 'dart:async' show Timer;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:home/network/models/state.dart';
import 'package:home/network/models/device.dart';
import 'package:home/network/device_service.dart';
import 'package:home/screens/controls/details.dart';

/// DeviceCard shows basic information about it's [device].
/// For all types of devices the name and the room will be shown, together with
/// the appropriate icon. For non-dimmable lamps, the power status will be shown.
/// For dimmable and colorful lamps, the brightness value will be shown
/// (If `power` is false, the brightness will be 0%). A speakers' status will either be
/// `playing` or `paused`
class DeviceCard extends StatefulWidget {
  final Device device;

  const DeviceCard(this.device, {Key key}) : super(key: key);

  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> with SingleTickerProviderStateMixin {
  Timer _timer;

  @override
  void initState() {
    super.initState();

    if (_timer != null) return;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      DeviceState state = await DeviceService.refresh(device: widget.device);

      // Only rebuild if the device state differs
      // from the refreshed state
      if (widget.device.state == state) return;

      setState(() => widget.device.state = state);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.device.state.error) return;

        DeviceState state = await DeviceService.update(device: widget.device);

        // Only rebuild if the device state differs
        // from the refreshed state
        if (widget.device.state == state) return;

        setState(() => widget.device.state = state);
      },
      onLongPress: () {
        showModalBottomSheet(context: context, builder: (_) => Details(device: widget.device));
      },
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 100),
        opacity: widget.device.state.power ?? false ? 1 : 0.4,
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).cardColor,
          ),
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.device.room.name,
                  style: Theme.of(context).textTheme.body2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    widget.device.name,
                    style: Theme.of(context).textTheme.body2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                StateLabel(device: widget.device),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StateLabel extends StatelessWidget {
  final Device device;

  const StateLabel({Key key, this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (device.state.error) {
      return Text(
        "No Response",
        style: Theme.of(context).textTheme.body2.copyWith(color: CupertinoColors.destructiveRed),
        maxLines: 1,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      );
    } else if (!device.state.power) {
      return Text(
        "Off",
        style:
            Theme.of(context).textTheme.body2.copyWith(color: Theme.of(context).textTheme.body2.color.withOpacity(0.5)),
        maxLines: 1,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      );
    } else if (device.state.power) {
      return Text(
        device.state.brightness != null ? "${device.state.brightness.value}%" : "On",
        style:
            Theme.of(context).textTheme.body2.copyWith(color: Theme.of(context).textTheme.body2.color.withOpacity(0.5)),
        maxLines: 1,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      );
    }

    return Text(
      "...",
      style:
          Theme.of(context).textTheme.body2.copyWith(color: Theme.of(context).textTheme.body2.color.withOpacity(0.5)),
      maxLines: 1,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
    );
  }
}
