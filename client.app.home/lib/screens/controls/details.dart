import 'package:flutter/material.dart';

import 'package:home/network/device_service.dart';
import 'package:home/network/models/device.dart';
import 'package:home/network/models/state.dart';

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
      height: MediaQuery.of(context).size.height * 0.9,
      color: Theme.of(context).cardColor,
      child: Stack(
        children: <Widget>[
          Center(
            child: GestureDetector(
              onTap: () async {
                if (widget.device.state.error) return;

                DeviceState state = await DeviceService.update(device: widget.device);

                // Only rebuild if the device state differs
                // from the refreshed state
                if (widget.device.state == state) return;

                setState(() => widget.device.state = state);
              },
              child: AnimatedOpacity(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF34C759),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: 200,
                  width: 150,
                  alignment: Alignment.center,
                ),
                duration: Duration(milliseconds: 100),
                opacity: widget.device.state.power ?? false ? 1 : 0.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
