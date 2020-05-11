import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:hive/hive.dart' show Hive;

class AccountSetup extends StatefulWidget {
  @override
  _AccountSetupState createState() => _AccountSetupState();
}

class _AccountSetupState extends State<AccountSetup> with SingleTickerProviderStateMixin {
  static String _first, _last;

  double height = 750;

  AnimationController _controller;
  CurvedAnimation curve;
  Animation<double> animation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    curve = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    animation = Tween<double>(begin: 450, end: 750).animate(curve)
      ..addListener(() {
        setState(() {
          print(animation.value);
          height = animation.value;
        });
      });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final valid = _first != null && _last != null;

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
          onPressed: () => Navigator.of(context).pop(),
        ),
        trailing: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: valid ? 1 : 0.2,
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).buttonColor,
                borderRadius: BorderRadius.circular(40),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 6),
              child: Text('Save', style: Theme.of(context).textTheme.button.copyWith(fontSize: 16)),
            ),
            onPressed: valid
                ? () {
                    Hive.box<String>('preferences').put('username', '$_first $_last');

                    Navigator.of(context).pushReplacementNamed('/home');
                  }
                : null,
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                onPanEnd: (details) {
                  _controller.forward(from: 450);
                },
                onPanUpdate: (details) {
                  setState(() {
                    height -= details.delta.dy * 0.5;
                  });
                },
                child: Container(
                  height: height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
