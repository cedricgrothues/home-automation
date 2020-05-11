import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Scaffold, Theme;

class SelectDevice extends StatelessWidget {
  const SelectDevice({Key key, this.devices}) : super(key: key);

  final Set<String> devices;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        border: null,
        automaticallyImplyLeading: false,
        automaticallyImplyMiddle: false,
        leading: CupertinoButton(
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Theme.of(context).buttonColor,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/home'),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).buttonColor,
              borderRadius: BorderRadius.circular(40),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
            child: Text('Next', style: Theme.of(context).textTheme.button.copyWith(fontSize: 16)),
          ),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/home');
          },
        ),
      ),
      body: Placeholder(),
    );
  }
}
