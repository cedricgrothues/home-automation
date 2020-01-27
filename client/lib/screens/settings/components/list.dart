import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Material, MaterialType, Theme;

/// Creates a scrollable, linear array of widgets from an explicit
/// [List] of headers and [List] of sections. This constructor is appropriate
/// for list views that should comply with home's design guidelines.
/// This list is supposed to be used within a [DraggableScrollableSheet].
class PopupList extends StatelessWidget {
  final ScrollController controller;
  final List<Widget> header;
  final List<Widget> sections;
  final String discard;

  const PopupList({Key key, @required this.controller, @required this.sections, this.header, this.discard = "Done"})
      : assert(controller != null),
        assert(sections != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> items = <Widget>[
      if (header != null) ...header,
      ...sections,
      CupertinoButton(
        padding: const EdgeInsets.only(top: 20),
        onPressed: () => Navigator.of(context).pop(),
        child: Container(
          height: 35,
          width: 90,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            discard,
            style: Theme.of(context).textTheme.subhead,
          ),
        ),
      )
    ];

    return SafeArea(
      top: false,
      bottom: false,
      child: Material(
        type: MaterialType.transparency,
        child: ListView.builder(
          controller: controller,
          itemBuilder: (context, index) => items[index],
          itemCount: items.length,
        ),
      ),
    );
  }
}
