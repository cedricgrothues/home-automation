import 'dart:convert' show base64;
import 'dart:typed_data' show Uint8List;

import 'package:flutter/cupertino.dart' show CupertinoButton, CupertinoNavigationBar;
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';

import 'package:home/network/device_service.dart';
import 'package:home/network/scene_service.dart';
import 'package:home/screens/add/brand.dart';
import 'package:home/screens/home/sections/device.dart';
import 'package:home/screens/home/sections/scenes.dart';
import 'package:home/screens/settings/settings.dart';

class Home extends StatelessWidget {
  final Uint8List _image = base64.decode(Hive.box<String>('preferences').get('picture') ?? '');

  // Futures and images for the underlying widgets are defines here,
  // so neither the FutureBuilder nor Image fires twice.
  final _devices = DeviceService.fetch();
  final _scenes = SceneService.fetch();

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
                Icons.add,
                size: 33,
              ),
              padding: EdgeInsets.zero,
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (context) => SelectBrand(),
                  isScrollControlled: true,
                );
              },
            ),
            trailing: CupertinoButton(
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
              padding: EdgeInsets.zero,
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (context) => Settings(),
                  isScrollControlled: true,
                );
              },
            ),
          ),
          body: PageView(
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              DeviceControl(devices: _devices),
              SceneControl(scenes: _scenes),
            ],
          ),
        ),
      ),
    );
  }
}
