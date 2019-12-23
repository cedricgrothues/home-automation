import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'package:home/components/icons.dart';
import 'package:home/network/models/device.dart';

// import 'package:home/screens/home/addons/music.dart';
import 'package:home/screens/home/addons/devices.dart';
// import 'package:home/screens/home/addons/scenes.dart';

import 'package:home/network/device_service.dart';
// import 'package:home/network/scenes_service.dart';
// import 'package:home/network/models/scene.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                image: MemoryImage(base64.decode(Hive.box<String>("preferences").get("picture"))),
                fit: BoxFit.cover,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).buttonColor,
                width: 1,
              ),
            ),
          ),
          padding: EdgeInsets.zero,
          onPressed: () {
            Box<String> box = Hive.box('preferences');
            box.delete('service.api-gateway');
          },
        ),
      ),
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
