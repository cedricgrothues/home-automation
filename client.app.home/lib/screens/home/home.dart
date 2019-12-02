import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                "Favorite Scenes",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: 170,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    direction: Axis.vertical,
                    children: List.generate(
                      9,
                      (i) => Scene(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                "Favorite Accessories",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(
                10,
                (i) => Device(
                  key: Key("$i"),
                  dimmable: i % 2 == 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Scene extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).cardColor,
      ),
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Bedroom Lamp",
              style: Theme.of(context).textTheme.body2.copyWith(fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class Device extends StatefulWidget {
  final bool dimmable;

  const Device({Key key, this.dimmable}) : super(key: key);

  @override
  _DeviceState createState() => _DeviceState();
}

class _DeviceState extends State<Device> {
  bool toggled = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => toggled = !toggled),
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 100),
        opacity: toggled ? 0.5 : 1,
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).cardColor,
          ),
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Bedroom Lamp",
                  style: Theme.of(context).textTheme.body2,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                Text(
                  widget.dimmable ? "100%" : "On",
                  style: Theme.of(context).textTheme.body2.copyWith(color: Theme.of(context).textTheme.body2.color.withOpacity(0.5)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
