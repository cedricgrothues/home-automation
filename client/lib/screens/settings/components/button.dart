import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Theme;

/// The [ButtonType] choosen defines the look
/// of the parent [PopupButton] Widget.
///
/// `ButtonType.destructive` should be choosen,
/// if the action might change or delete data.
/// Destructive buttons have a red background.
enum ButtonType {
  normal,
  destructive,
}

/// Creates a button that is supposed to be
/// used within a [PopupList]
class PopupButton extends StatelessWidget {
  const PopupButton({Key key, this.onPressed, @required this.child, this.type = ButtonType.normal, this.height = 66})
      : super(key: key);

  final Function() onPressed;
  final Widget child;
  final ButtonType type;
  final double height;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: type == ButtonType.normal ? Theme.of(context).cardColor : Theme.of(context).errorColor,
          borderRadius: BorderRadius.circular(15),
        ),
        width: double.infinity,
        height: height,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 25),
        alignment: Alignment.centerLeft,
        child: child,
      ),
    );
  }
}
