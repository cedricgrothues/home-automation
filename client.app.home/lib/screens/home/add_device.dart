import 'package:flutter/material.dart';

class AddDevice extends StatefulWidget {
  @override
  _AddDeviceState createState() => _AddDeviceState();
}

final List<String> brands = ["Sonos", "Sonoff", "Phillips Hue"];

class _AddDeviceState extends State<AddDevice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            if (index > 0)
              return Column(
                children: <Widget>[
                  DeviceBrand(
                    name: brands[index - 1],
                  ),
                  Divider(indent: 16, endIndent: 16)
                ],
              );
            else
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: FeaturedBrands(),
              );
          },
          itemCount: brands.length + 1,
        ),
      ),
    );
  }
}

class FeaturedBrands extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: 85,
            height: 85,
            margin: EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.03),
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
        itemCount: 4,
      ),
    );
  }
}

class DeviceBrand extends StatelessWidget {
  final String name;

  const DeviceBrand({Key key, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        name,
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }
}
