import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Today extends StatefulWidget {
  @override
  _TodayState createState() => _TodayState();
}

class _TodayState extends State<Today> {
  final colors = <Color>[
    Colors.indigo[400],
    Colors.cyan,
    Colors.green[400],
    Colors.teal,
    Colors.amber,
    Colors.orange,
    Colors.red[400],
    Colors.pink[400],
    Colors.purple[300],
    Colors.purple,
    Colors.brown[400],
    Colors.grey,
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            Wrap(
              runSpacing: 15,
              spacing: 15,
              children: List.generate(
                colors.length,
                (index) => Container(
                  decoration: BoxDecoration(
                    color: colors[index],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                  ),
                  height: 50,
                  width: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
