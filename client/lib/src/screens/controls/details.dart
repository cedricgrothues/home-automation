import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoButton;

import 'package:home/src/network/models/device.dart';
import 'package:home/src/components/labels.dart';

/// Use [DeviceDetails] if the user long-presses
/// on a [DeviceCard]. It shows in-depth information
/// on the device and provides fine-grained control
/// over the device.
class DeviceDetails extends StatefulWidget {
  const DeviceDetails(this.device, {Key key}) : super(key: key);

  final Device device;

  @override
  _DeviceDetailsState createState() => _DeviceDetailsState();
}

class _DeviceDetailsState extends State<DeviceDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.94,
          constraints: const BoxConstraints(maxWidth: 420),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: CupertinoButton(
                    padding: const EdgeInsets.all(18),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).toggleButtonsTheme.fillColor,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.close,
                        color: Theme.of(context).toggleButtonsTheme.color,
                        size: 20,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30, horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            widget.device.name ?? 'None',
                            style: Theme.of(context).textTheme.headline5,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        StateLabel(
                          device: widget.device,
                          style: Theme.of(context).textTheme.caption,
                          long: true,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
