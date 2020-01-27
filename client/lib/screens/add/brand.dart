import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Material, MaterialType, Theme;

import 'package:home/components/icons.dart' show RegularIcons;
import 'package:home/screens/settings/components/button.dart';
import 'package:home/screens/settings/components/list.dart';
import 'package:home/services/ssdp.dart' show SSDP;

/// [SelectBrand] screen is the first screen the user sees,
/// when the add device button is pressed. It's use is, as
/// expected, to offer the user a selection of possible brands and
/// store the proper way to discover the a new [Device] (`SSDP` or `IP`)
class SelectBrand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: DraggableScrollableSheet(
        minChildSize: 0.9,
        initialChildSize: 0.9,
        builder: (BuildContext context, ScrollController controller) {
          return Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: PopupList(
                controller: controller,
                discard: "Cancel",
                header: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 35, top: 20, bottom: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Add a new device",
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Icon(RegularIcons.times, size: 24),
                          onPressed: () => Navigator.of(context).pop(),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
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
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Icon(
                            RegularIcons.lightbulb_dollar,
                            size: 30,
                          ),
                        ),
                        Text("Nanoleaf Aurora"),
                      ],
                    ),
                    onPressed: () async {
                      String addr = await SSDP().discover(query: "nanoleaf_aurora:light").first;
                      print(addr);
                    },
                    height: 85,
                  ),
                  PopupButton(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Icon(
                            RegularIcons.speaker,
                            size: 30,
                          ),
                        ),
                        Text("Sonos Speaker"),
                      ],
                    ),
                    onPressed: () {},
                    height: 85,
                  ),
                  PopupButton(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Icon(
                            RegularIcons.lightbulb,
                            size: 30,
                          ),
                        ),
                        Text("Sonoff Device"),
                      ],
                    ),
                    onPressed: () {},
                    height: 85,
                  ),
                  PopupButton(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Icon(
                            RegularIcons.lamp,
                            size: 30,
                          ),
                        ),
                        Text("Hue Lamp"),
                      ],
                    ),
                    height: 85,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
