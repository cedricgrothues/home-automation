import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({Key key, this.title, this.onPressed, this.width})
      : super(key: key);

  final String title;
  final double width;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).buttonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        constraints: BoxConstraints(maxWidth: 300),
        width: width ?? 100,
        child: Text(
          title,
          maxLines: 1,
          style: Theme.of(context).textTheme.button,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
