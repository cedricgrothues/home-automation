import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:home/src/screens/settings/components/button.dart';
import 'package:home/src/screens/settings/components/list.dart';

class ChangeAppIcon extends StatelessWidget {
  static final List<String> icons = [
    'Default',
    'Classic',
    'Orange',
    'Coloring Book',
    'Vine',
    'Byte',
    'Pearl',
    'RGB'
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: 0.9,
      initialChildSize: 0.9,
      builder: (BuildContext context, ScrollController controller) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: PopupList(
            header: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 35, top: 10, bottom: 10, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Change App Icon',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: Icon(Icons.close, size: 26),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                ),
              ),
            ],
            controller: controller,
            sections: List.generate(
              icons.length,
              (i) => PopupButton(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Image.asset(
                          'assets/themes/${icons[i].split(' ').join('-').toLowerCase()}.png',
                          height: 42),
                    ),
                    Text(
                      icons[i],
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                height: 85,
              ),
            ),
          ),
        );
      },
    );
  }
}
