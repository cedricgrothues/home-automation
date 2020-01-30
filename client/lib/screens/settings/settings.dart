import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons, Theme, showLicensePage, showModalBottomSheet;

import 'package:hive/hive.dart' show Hive;
import 'package:url_launcher/url_launcher.dart' show launch;

import 'package:home/screens/settings/sections/appicon.dart';
import 'package:home/screens/settings/components/list.dart';
import 'package:home/screens/settings/components/button.dart';
import 'package:home/screens/settings/components/section.dart';

/// Defines the main [Settings] page. This is show
/// when the user taps on their profile picture.
class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: 0.9,
      initialChildSize: 0.9,
      builder: (BuildContext context, ScrollController controller) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: PopupList(
            header: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 35, top: 20, bottom: 10, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Settings",
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Icon(Icons.close, size: 26),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                ),
              ),
            ],
            controller: controller,
            sections: <Widget>[
              Section(
                items: <Widget>[
                  PopupButton(
                    child: Text("Star the GitHub Repo"),
                    onPressed: () => launch("https://github.com/cedricgrothues/home-automation"),
                  ),
                ],
              ),
              Section(
                title: "App Settings",
                items: <Widget>[
                  PopupButton(
                    child: Text("Change app icon"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      showModalBottomSheet(
                        builder: (BuildContext context) => ChangeAppIcon(),
                        context: context,
                        isScrollControlled: true,
                      );
                    },
                  ),
                  PopupButton(
                    child: Text("Change polling timeout"),
                    onPressed: () {},
                  ),
                ],
              ),
              Section(
                title: "Troubleshooting",
                items: <Widget>[
                  PopupButton(
                    child: Text("View open issues"),
                    onPressed: () {},
                  ),
                  PopupButton(
                    child: Text("Forum & Support"),
                    onPressed: () => launch("https://github.com/cedricgrothues/home-automation/issues"),
                  ),
                  PopupButton(
                    child: Text("Show active projects"),
                    onPressed: () => launch("https://github.com/cedricgrothues/home-automation/projects"),
                  ),
                ],
              ),
              Section(
                title: "Credits",
                items: <Widget>[
                  PopupButton(
                    child: Text("Open Source"),
                    onPressed: () {
                      showLicensePage(
                        context: context,
                        applicationLegalese: "Copyright © 2020 Cedric Grothues",
                        applicationVersion: "0.1.0-dev.1",
                        applicationName: "Home Assistent",
                      );
                    },
                  ),
                  PopupButton(
                    child: Text("Visit the Repository"),
                    onPressed: () {},
                  ),
                ],
              ),
              Section(
                title: "Account",
                items: <Widget>[
                  PopupButton(
                    child: Text("Change username or profile picture"),
                    onPressed: () => Navigator.of(context).pushReplacementNamed("/account_setup"),
                  ),
                  PopupButton(
                    child: Text(
                      "Log out",
                      style: TextStyle(color: Color(0xfffa5b70)),
                    ),
                    onPressed: () async {
                      await Hive.deleteFromDisk();
                      Navigator.of(context).pushReplacementNamed("/");
                    },
                    type: ButtonType.destructive,
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
