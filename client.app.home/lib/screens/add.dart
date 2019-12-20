import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:home/components/icons.dart';

class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  static bool enabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        border: null,
        leading: CupertinoButton(
          child: Icon(
            LightIcons.times,
          ),
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
        ),
        trailing: AnimatedOpacity(
          child: CupertinoButton(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 14),
              decoration: BoxDecoration(
                color: Theme.of(context).buttonColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Add",
                style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor, fontWeight: FontWeight.w600),
              ),
            ),
            padding: EdgeInsets.zero,
            onPressed: enabled ? () => Navigator.of(context).pop() : null,
          ),
          opacity: enabled ? 1 : 0.2,
          duration: Duration(milliseconds: 100),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ListView(
          children: <Widget>[
            Wrap(
              runSpacing: 10,
              spacing: 10,
              children: <Widget>[
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).cardColor,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    RegularIcons.lightbulb,
                    size: 30,
                  ),
                ),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).cardColor,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    RegularIcons.plug,
                    size: 30,
                  ),
                ),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).cardColor,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    RegularIcons.speaker,
                    size: 30,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
