import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Material, MaterialType, Theme;

/// Creates a scrollable, linear array of widgets from an explicit
/// [List] of headers and [List] of sections. This constructor is appropriate
/// for list views that should comply with home's design guidelines.
/// This list is supposed to be used within a [DraggableScrollableSheet].
class PopupList extends StatelessWidget {
  PopupList({Key key, this.controller, @required this.sections, this.header, this.discard, this.discardAction})
      : assert(sections != null),
        super(key: key);

  final ScrollController controller;
  final List<Widget> header;
  final List<Widget> sections;
  final String discard;
  final void Function(BuildContext) discardAction;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      if (header != null) ...header,
      ...sections,
      if (discard != null)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CupertinoButton(
              padding: const EdgeInsets.symmetric(vertical: 20),
              onPressed: () => discardAction != null
                  ? discardAction(context)
                  : (BuildContext context) => Navigator.of(context).pop(),
              child: Container(
                height: 35,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  discard,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ),
          ],
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
