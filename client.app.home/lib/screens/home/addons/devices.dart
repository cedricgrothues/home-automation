import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:home/models/device.dart';
import 'package:home/models/errors.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Devices extends StatelessWidget {
  static Future<List<DeviceModel>> fetch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    http.Response response = await http.get("http://${prefs.getString("service.api-gateway")}:4000/service.device-registry");

    if (response.statusCode != 200) throw StatusCodeError();

    List<dynamic> devices = json.decode(response.body);

    return devices.map((dynamic device) => DeviceModel.fromMap(Map.from(device))).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<DeviceModel> devices = Provider.of<List<DeviceModel>>(context);

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      direction: Axis.horizontal,
      children: devices != null ? devices.map((device) => Device(device)).toList() : [],
    );
  }
}

class Device extends StatefulWidget {
  final DeviceModel device;

  const Device(this.device, {Key key}) : super(key: key);

  @override
  _DeviceState createState() => _DeviceState();
}

class _DeviceState extends State<Device> {
  bool toggled = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      pressedOpacity: 0.6,
      padding: EdgeInsets.zero,
      onPressed: () => setState(() => toggled = !toggled),
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 100),
        opacity: toggled ? 0.4 : 1,
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
                  widget.device.name ?? "",
                  style: Theme.of(context).textTheme.body2,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                Text(
                  widget.device.state ?? "...",
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
