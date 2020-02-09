import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' show CupertinoButton;

import 'package:home/network/models/scene.dart';
import 'package:home/network/scene_service.dart';

/// SceneCard shows basic information about it's [scene].
/// For all types of scenes the name together with the
/// appropriate icon will be shown.
class SceneCard extends StatelessWidget {
  const SceneCard(this.scene, {Key key}) : super(key: key);

  final Scene scene;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => SceneService.run(scene),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.indigo[400],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: CupertinoButton(
                padding: const EdgeInsets.all(10),
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
              alignment: Alignment.bottomLeft,
              child: Padding(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      scene?.name ?? 'None',
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Text(
                        '${scene.actions?.length ?? 0} action${(scene.actions?.length ?? 0) <= 1 ? '' : 's'}',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
