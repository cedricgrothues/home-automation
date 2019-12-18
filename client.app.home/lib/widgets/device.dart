import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:home/network/models/device.dart';
import 'package:home/network/device_service.dart';

class DeviceCard extends StatefulWidget {
  final Device device;

  const DeviceCard(this.device, {Key key}) : super(key: key);

  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 5), (timer) async {
      if (!ModalRoute.of(context).isCurrent) timer.cancel();
      widget.device.state = await DeviceService.refresh(device: widget.device);
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.device.state.containsKey("error")) return;

        Map state = await DeviceService.update(device: widget.device);
        setState(() => widget.device.state = state);
      },
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 100),
        opacity: (widget.device.state["power"]) ? 1 : 0.4,
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
                  widget.device.name ?? "",
                  style: Theme.of(context).textTheme.body2,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
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
    if (device.state.containsKey("error")) {
      return Text(
        "No Response",
        style: Theme.of(context).textTheme.body2.copyWith(color: CupertinoColors.destructiveRed),
        maxLines: 1,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      );
    }
    return device.state["power"]
        ? Text(
            "On",
            style: Theme.of(context)
                .textTheme
                .body2
                .copyWith(color: Theme.of(context).textTheme.body2.color.withOpacity(0.5)),
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          )
        : Text(
            "Off",
            style: Theme.of(context)
                .textTheme
                .body2
                .copyWith(color: Theme.of(context).textTheme.body2.color.withOpacity(0.5)),
            maxLines: 1,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          );
  }
}
