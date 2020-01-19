import 'package:flutter/material.dart';

import 'package:home/widgets/scene.dart';

class Scenes extends StatefulWidget {
  @override
  _ScenesState createState() => _ScenesState();
}

class _ScenesState extends State<Scenes> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 240.0,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 3 / 2,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return SceneCard();
              },
              childCount: 5,
            ),
          ),
        ),
      ],
    );
  }
}
