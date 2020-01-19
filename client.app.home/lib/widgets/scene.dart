import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoButton;
import 'package:home/components/icons.dart';

class SceneCard extends StatefulWidget {
  @override
  _SceneCardState createState() => _SceneCardState();
}

class _SceneCardState extends State<SceneCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.teal[300],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: CupertinoButton(
                padding: EdgeInsets.all(10),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white24,
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.more_horiz, color: Colors.white),
                ),
                onPressed: () {},
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Icon(RegularIcons.person_sign, color: Colors.white),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                child: Text(
                  "Leave Home",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                padding: EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
