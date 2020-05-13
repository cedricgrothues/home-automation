import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons, Scaffold;

import 'package:home/src/models/device.dart';
import 'package:home/src/components/routes.dart';
import 'package:home/src/screens/add/discover.dart';
import 'package:home/src/screens/settings/components/button.dart';
import 'package:home/src/screens/settings/components/list.dart';

/// [SelectBrand] screen is the first screen the user sees,
/// when the add device button is pressed. It's use is, as
/// expected, to offer the user a selection of possible brands and
/// store the proper way to discover the a new [Device] (`SSDP` or `IP`)
class SelectBrand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.only(top: 20),
      child: Scaffold(
        appBar: CupertinoNavigationBar(
          automaticallyImplyLeading: false,
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Icon(Icons.close, size: 26),
            onPressed: () => Navigator.of(context).pop(),
          ),
          border: null,
        ),
        body: PopupList(
          discardAction: (context) => Navigator.of(context).pop(),
          discard: 'Cancel',
          header: <Widget>[
            const Padding(
              padding:
                  EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 10),
              child: Text(
                "Choose the type of device you want to add. Make sure to choose the right brand, otherwise you might no be able to utelize all of the app's features",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFa2acbe),
                ),
              ),
            ),
          ],
          sections: <Widget>[
            PopupButton(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: const <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Text('🛋', style: TextStyle(fontSize: 22)),
                  ),
                  Text('Nanoleaf Aurora'),
                ],
              ),
              onPressed: () {
                // If we assume the discover function does not throw an exception, there is three
                // possible outcomes to the function.
                //
                // 1. No devices found
                // 2. One device found
                // 3. More then 1 devices found

                Navigator.of(context).push(
                  FadeTransitionRoute<void>(
                    child: Discover(
                      target: 'nanoleaf_aurora:light',
                      controller: 'modules.aurora',
                    ),
                  ),
                );
              },
              height: 85,
            ),
            PopupButton(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: const <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Text('🔊', style: TextStyle(fontSize: 22)),
                  ),
                  Text('Sonos Speaker'),
                ],
              ),
              height: 85,
            ),
            PopupButton(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: const <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Text('🔌', style: TextStyle(fontSize: 22)),
                  ),
                  Text('Sonoff Device'),
                ],
              ),
              height: 85,
            ),
            PopupButton(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: const <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Text('💡', style: TextStyle(fontSize: 22)),
                  ),
                  Text('Hue Lamp'),
                ],
              ),
              height: 85,
            ),
          ],
        ),
      ),
    );
  }
}
