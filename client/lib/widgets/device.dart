import 'dart:async' show Timer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;

import 'package:pedantic/pedantic.dart';

import 'package:home/components/labels.dart';
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
      var state = await DeviceService.refresh(device: widget.device);

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

        // Simulate a short tap to give
        // the user haptic feedback
        unawaited(HapticFeedback.heavyImpact());

        var state = await DeviceService.update(device: widget.device);

        // Only rebuild if the device state differs
        // from the refreshed state
        if (widget.device.state == state) return;

        setState(() => widget.device.state = state);
      },
      onLongPress: () {
        // Simulate a short tap to give
        // the user haptic feedback
        HapticFeedback.heavyImpact();

        showModalBottomSheet(
          context: context,
          builder: (context) => DeviceDetails(widget.device),
          isScrollControlled: true,
        );
      },
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 100),
        opacity: widget.device.state.power ?? false ? 1 : 0.5,
        child: Container(
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
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  widget.device.room.name,
                  style: Theme.of(context).textTheme.bodyText1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    widget.device.name,
                    style: Theme.of(context).textTheme.bodyText1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                StateLabel(
                  device: widget.device,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(color: Color(0xFF99999E)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
