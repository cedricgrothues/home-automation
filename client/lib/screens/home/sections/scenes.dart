import 'package:flutter/material.dart';

import 'package:home/widgets/scene.dart';
import 'package:home/network/models/scene.dart';

class SceneControl extends StatefulWidget {
  const SceneControl({Key key, this.scenes}) : super(key: key);

  final Future<List<Scene>> scenes;

  @override
  _SceneControlState createState() => _SceneControlState();
}

class _SceneControlState extends State<SceneControl> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        FutureBuilder<List<Scene>>(
          future: widget.scenes,
          initialData: const [],
          builder: (context, snapshot) {
            final cards = snapshot.data.map((scene) => SceneCard(scene, key: Key(scene.id))).toList();

            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 240.0,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 3 / 2,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => cards[index],
                  childCount: cards.length,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
