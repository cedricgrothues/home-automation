import 'dart:typed_data' show Uint8List;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

/// [AddSheet] defines the `CupertinoActionSheet` the user sees,
/// when home.dart's add button is pressed
class AddSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: <Widget>[
        CupertinoActionSheetAction(
          onPressed: () => null,
          child: const Text('Add Accessory'),
        ),
        CupertinoActionSheetAction(
          onPressed: () => null,
          child: const Text('Add Scene'),
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: const Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}

/// [ProfileSheet] defines the `CupertinoActionSheet` the user sees,
/// when the profile image is tapped
class ProfileSheet extends StatefulWidget {
  const ProfileSheet(this.bytes, {Key key}) : super(key: key);

  final Uint8List bytes;

  @override
  _ProfileSheetState createState() => _ProfileSheetState();
}

class _ProfileSheetState extends State<ProfileSheet> {
  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 100,
            height: 100,
            margin: const EdgeInsets.symmetric(vertical: 25),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: MemoryImage(widget.bytes),
                fit: BoxFit.cover,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).buttonColor,
                width: 2,
              ),
            ),
          ),
          Text(Hive.box<String>('preferences').get('username'), style: TextStyle(color: Colors.white, fontSize: 18))
        ],
      ),
      message: const Text('Copyright © 2020 Cedric Grothues. All rights reserved.'),
      actions: <Widget>[
        CupertinoActionSheetAction(
          onPressed: () => null,
          child: const Text('About this app'),
        ),
        CupertinoActionSheetAction(
          onPressed: () => null,
          child: const Text('Open Preferences'),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: const Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
