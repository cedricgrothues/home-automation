import 'dart:convert' show base64;
import 'dart:typed_data' show Uint8List;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';

import 'package:home/components/icons.dart';
import 'package:home/network/device_service.dart';
import 'package:home/network/models/device.dart';
import 'package:home/screens/home/sections/control.dart';
import 'package:home/screens/home/sections/scenes.dart';
import 'package:home/screens/home/sections/today.dart';

class Home extends StatelessWidget {
  final Uint8List _image = base64.decode(Hive.box<String>("preferences").get("picture"));

  // Futures for the underlying widgets are defines here,
  // so the FutureBuilder doesn't fire unintentionally
  final Future<List<Device>> _devices = DeviceService.fetch();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: SafeArea(
        minimum: const EdgeInsets.only(top: 20),
        child: Scaffold(
          appBar: CupertinoNavigationBar(
            border: null,
            leading: CupertinoButton(
              child: Icon(
                LightIcons.plus,
              ),
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.of(context).pushNamed("/add"),
            ),
            trailing: CupertinoButton(
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: MemoryImage(_image),
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).buttonColor,
                    width: 1.5,
                  ),
                ),
              ),
              padding: EdgeInsets.zero,
              onPressed: () {
                // Open the profile screen here
              },
            ),
          ),
          body: PageView(
            physics: AlwaysScrollableScrollPhysics(),
            children: <Widget>[Today(), DeviceControl(devices: _devices), Scenes()],
          ),
        ),
      ),
    );
  }
}
