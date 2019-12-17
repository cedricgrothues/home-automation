import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home/network/models/device.dart';

import 'package:provider/provider.dart';

import 'package:home/screens/home/addons/music.dart';
import 'package:home/screens/home/addons/devices.dart';
import 'package:home/screens/home/addons/scenes.dart';

import 'package:home/network/device_service.dart';
import 'package:home/network/scenes_service.dart';
import 'package:home/network/models/scene.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            // Music(),
            // FutureProvider<List<Scene>>.value(
            //   value: SceneService.fetch(),
            //   child: Scenes(),
            //   catchError: (context, error) => [],
            // ),
            FutureProvider<List<Device>>.value(
              value: DeviceService.fetch(),
              child: Devices(),
              catchError: (context, error) => [],
            )
          ],
        ),
      ),
    );
  }
}
