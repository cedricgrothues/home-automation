import 'package:flutter/material.dart';

class LightController extends StatefulWidget {
  final String id;
  final bool dimmable;
  final bool colorful;

  const LightController({Key key, this.dimmable = false, this.colorful = false, @required this.id}) : super(key: key);

  @override
  _LightControllerState createState() => _LightControllerState();
}

class _LightControllerState extends State<LightController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(),
    );
  }
}
