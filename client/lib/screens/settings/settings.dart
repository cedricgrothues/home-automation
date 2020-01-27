import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Theme;

import 'package:hive/hive.dart' show Hive;
import 'package:url_launcher/url_launcher.dart' show launch;

import 'package:home/components/icons.dart' show RegularIcons;
import 'package:home/screens/settings/components/button.dart';
import 'package:home/screens/settings/components/list.dart';
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
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                      child: Icon(RegularIcons.times, size: 24),
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
                    child: Text(
                      "Star the GitHub Repo",
                    ),
                    onPressed: () => launch("https://github.com/cedricgrothues/home-automation"),
                  ),
                ],
              ),
              Section(
                title: "App Settings",
                items: <Widget>[
                  PopupButton(
                    child: Text(
                      "Change app icon",
                    ),
                    onPressed: () {},
                  ),
                  PopupButton(
                    child: Text(
                      "Change polling timeout",
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              Section(
                title: "Troubleshooting",
                items: <Widget>[
                  PopupButton(
                    child: Text(
                      "View open issues",
                    ),
                    onPressed: () {},
                  ),
                  PopupButton(
                    child: Text(
                      "Forum & Support",
                    ),
                    onPressed: () => launch("https://github.com/cedricgrothues/home-automation/issues"),
                  ),
                  PopupButton(
                    child: Text(
                      "Show active projects",
                    ),
                    onPressed: () => launch("https://github.com/cedricgrothues/home-automation/projects"),
                  ),
                ],
              ),
              Section(
                title: "Account",
                items: <Widget>[
                  PopupButton(
                    child: Text(
                      "Change username or profile picture",
                    ),
                    onPressed: () => null,
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
