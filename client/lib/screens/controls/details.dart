import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoButton;

import 'package:home/components/icons.dart';
import 'package:home/components/labels.dart';
import 'package:home/network/models/device.dart';

/// Details is called on a long-press on a `DeviceCard`.
/// It shows detailed information on the device and
/// provides more in-depth control over the device.
class DeviceDetails extends StatefulWidget {
  final Device device;

  const DeviceDetails(this.device, {Key key}) : super(key: key);

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
          height: MediaQuery.of(context).size.height * 0.85,
          constraints: BoxConstraints(maxWidth: 420),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.only(
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
                    padding: EdgeInsets.all(18),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).toggleButtonsTheme.fillColor,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        LightIcons.times,
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
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            widget.device.name,
                            style: Theme.of(context).textTheme.headline,
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