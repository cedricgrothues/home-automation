import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Theme;

/// The [Button] class defines the standard style for a button in client.app.home.
/// The title size is adjusted to fit the [Button]s width.
///
/// Since the [Button] relies on a [CupertinoButton], it'll have an onPressed animation.
/// To disable the button, set the `onPressed` property to `null`
class Button extends StatelessWidget {
  const Button({Key key, this.title, this.onPressed, this.width}) : super(key: key);

  final String title;
  final double width;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'button',
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).buttonColor,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          constraints: const BoxConstraints(maxWidth: 300),
          width: width ?? 100,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              title,
              maxLines: 1,
              style: Theme.of(context).textTheme.button,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
