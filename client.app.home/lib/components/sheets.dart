import 'dart:typed_data' show Uint8List;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// [AddSheet] defines the `CupertinoActionSheet` the user sees,
/// when home.dart's add button is pressed
class AddSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: <Widget>[
        CupertinoActionSheetAction(
          onPressed: () => null,
          child: Text("Add Accessory"),
        ),
        CupertinoActionSheetAction(
          onPressed: () => null,
          child: Text("Add Scene"),
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text("Cancel"),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}

/// [ProfileSheet] defines the `CupertinoActionSheet` the user sees,
/// when the profile image is tapped
class ProfileSheet extends StatelessWidget {
  final Uint8List bytes;

  const ProfileSheet(this.bytes, {Key key}) : super(key: key);

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
            margin: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: MemoryImage(bytes),
                fit: BoxFit.cover,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).buttonColor,
                width: 2,
              ),
            ),
          ),
        ],
      ),
      message: Text("Manage your account, update your profile picture, change your display name or open the settings."),
      actions: <Widget>[
        CupertinoActionSheetAction(
          onPressed: () => null,
          child: Text("Update your profile picture"),
        ),
        CupertinoActionSheetAction(
          onPressed: () => null,
          child: Text("Change your display name"),
        ),
        CupertinoActionSheetAction(
          onPressed: () => null,
          child: Text("Open Preferences"),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text("Cancel"),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
