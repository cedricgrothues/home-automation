import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:home/network/models/scene.dart';
import 'package:home/components/regular_icons.dart';

import 'package:home/network/scenes_service.dart';

class SceneCard extends StatelessWidget {
  final Scene scene;

  const SceneCard({Key key, this.scene}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).cardColor,
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                RegularIcons.adjust,
                color: Theme.of(context).iconTheme.color,
                size: Theme.of(context).iconTheme.size,
              ),
              SizedBox(width: 15),
              Text(
                scene.name,
                style: Theme.of(context).textTheme.body2.copyWith(fontSize: 16),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
      onPressed: () => SceneService.trigger(scene),
    );
  }
}
