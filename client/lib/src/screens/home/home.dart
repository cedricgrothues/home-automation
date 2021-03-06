import 'dart:convert' show base64;
import 'dart:typed_data' show Uint8List;

import 'package:flutter/cupertino.dart'
    show CupertinoButton, CupertinoNavigationBar;
import 'package:flutter/material.dart';

import 'package:hive/hive.dart' show Hive;

import 'package:home/src/network/scene_service.dart';
import 'package:home/src/network/device_service.dart';
import 'package:home/src/screens/home/sections/device.dart';
import 'package:home/src/screens/home/sections/scenes.dart';
import 'package:home/src/screens/home/sections/today.dart';

class Home extends StatelessWidget {
  final Uint8List _image =
      base64.decode(Hive.box<String>('preferences').get('picture') ?? '');

  // Any `Future<T>` for the underlying widgets are defined here,
  // so the FutureBuilders, don't rerun on every rebuild.
  final _devices = DeviceService.fetch();
  final _scenes = SceneService.fetch();

  final _controller = PageController(initialPage: 1);

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
            trailing: CupertinoButton(
              child: Icon(
                Icons.add,
                size: 33,
                semanticLabel: 'add device',
              ),
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.of(context).pushNamed('/choose_brand'),
            ),
            leading: CupertinoButton(
              child: Semantics(
                hint: 'profile',
                child: Container(
                  width: 33,
                  height: 33,
                  decoration: BoxDecoration(
                    image: _image.isEmpty
                        ? DecorationImage(
                            image: AssetImage('assets/images/failed.png'),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
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
              ),
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.of(context).pushNamed('/settings'),
            ),
          ),
          body: PageView(
            controller: _controller,
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              Today(),
              DeviceControl(devices: _devices),
              SceneControl(scenes: _scenes),
            ],
          ),
        ),
      ),
    );
  }
}
