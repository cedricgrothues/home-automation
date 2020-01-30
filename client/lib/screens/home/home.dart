import 'dart:convert' show base64;
import 'dart:typed_data' show Uint8List;

import 'package:flutter/cupertino.dart' show CupertinoNavigationBar, CupertinoButton;
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';

import 'package:home/network/device_service.dart';
import 'package:home/network/models/device.dart';
import 'package:home/screens/add/brand.dart';
import 'package:home/screens/home/sections/control.dart';
import 'package:home/screens/settings/settings.dart';

class Home extends StatelessWidget {
  final Uint8List _image = base64.decode(Hive.box<String>('preferences').get('picture') ?? '');

  // Futures and images for the underlying widgets are defines here,
  // so neither the FutureBuilder nor Image fires twice.
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
                Icons.add,
                size: 30,
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
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  image: _image.isNotEmpty
                      ? DecorationImage(
                          image: MemoryImage(_image),
                          fit: BoxFit.cover,
                        )
                      : null,
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
          body: DeviceControl(devices: _devices),
        ),
      ),
    );
  }
}
