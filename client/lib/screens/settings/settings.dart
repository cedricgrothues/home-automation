import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons, Scaffold, showLicensePage, showModalBottomSheet, TextStyle, Text;

import 'package:hive/hive.dart' show Hive;
import 'package:pedantic/pedantic.dart' show unawaited;
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
          discard: 'Done',
          sections: <Widget>[
            Section(
              items: <Widget>[
                PopupButton(
                  child: const Text('Star the GitHub Repo'),
                  onPressed: () => launch('https://github.com/cedricgrothues/home-automation'),
                ),
              ],
            ),
            Section(
              title: 'App Settings',
              items: <Widget>[
                PopupButton(
                  child: const Text('Change app icon'),
                  onPressed: () {
                    showModalBottomSheet<void>(
                      builder: (BuildContext context) => ChangeAppIcon(),
                      context: context,
                      isScrollControlled: true,
                    );
                  },
                ),
                PopupButton(
                  child: const Text('Change polling timeout'),
                  onPressed: () {},
                ),
              ],
            ),
            Section(
              title: 'Troubleshooting',
              items: <Widget>[
                PopupButton(
                  child: const Text('View open issues'),
                  onPressed: () {},
                ),
                PopupButton(
                  child: const Text('Forum & Support'),
                  onPressed: () => launch('https://github.com/cedricgrothues/home-automation/issues'),
                ),
                PopupButton(
                  child: const Text('Show active projects'),
                  onPressed: () => launch('https://github.com/cedricgrothues/home-automation/projects'),
                ),
              ],
            ),
            Section(
              title: 'Credits',
              items: <Widget>[
                PopupButton(
                  child: const Text('Open Source'),
                  onPressed: () {
                    showLicensePage(
                      context: context,
                      applicationLegalese: 'Copyright © 2020 Cedric Grothues',
                      applicationVersion: '0.1.0',
                      applicationName: 'Home Assistent',
                    );
                  },
                ),
                PopupButton(
                  child: const Text('Visit the Repository'),
                  onPressed: () {},
                ),
              ],
            ),
            Section(
              title: 'Account',
              items: <Widget>[
                PopupButton(
                  child: const Text('Update account'),
                  onPressed: () => Navigator.of(context).pushReplacementNamed('/account'),
                ),
                PopupButton(
                  child: const Text(
                    'Log out',
                    style: TextStyle(color: Color(0xfffa5b70)),
                  ),
                  onPressed: () async {
                    await Hive.deleteFromDisk();
                    unawaited(Navigator.of(context).pushReplacementNamed('/'));
                  },
                  type: ButtonType.destructive,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
