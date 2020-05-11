import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoneFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        border: null,
        automaticallyImplyLeading: false,
        automaticallyImplyMiddle: false,
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).buttonColor,
              borderRadius: BorderRadius.circular(40),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
            child: Text('Done', style: Theme.of(context).textTheme.button.copyWith(fontSize: 16)),
          ),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
        ),
      ),
      body: Placeholder(),
    );
  }
}
