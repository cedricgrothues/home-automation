import 'package:flutter/material.dart';

/// Defines a [Section] in a [PopupList].
///
/// While the [title] may be null, items may not.
class Section extends StatelessWidget {
  const Section({Key key, this.title, @required this.items})
      : assert(items != null),
        super(key: key);

  final String title;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (title != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 35),
            child: Material(
              type: MaterialType.transparency,
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, color: Color(0xFFa2acbe)),
              ),
            ),
          ),
        ...items,
      ],
    );
  }
}
