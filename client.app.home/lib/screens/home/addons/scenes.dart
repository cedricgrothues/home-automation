import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:home/widgets/scene.dart';
import 'package:home/network/models/scene.dart';

class Scenes extends StatefulWidget {
  @override
  _ScenesState createState() => _ScenesState();
}

class _ScenesState extends State<Scenes> {
  @override
  Widget build(BuildContext context) {
    List<Scene> scenes = Provider.of<List<Scene>>(context);

    return Wrap(
      runSpacing: 10,
      spacing: 10,
      children: scenes.map((scene) => SceneCard(scene: scene)).take(3).toList(),
    );
  }
}
