import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeviceModel {
  String id;
  String name;
  String type;
  String controller;
  String address;
  Room room;
  String state;

  DeviceModel({this.id, this.name, this.type, this.controller, this.address, this.room});

  DeviceModel.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    controller = json['controller'];
    address = json['address'];
    room = json['room'] != null ? new Room.fromMap(json['room']) : null;
    _state(id: json['id'], controller: json['controller']).then((s) => state = s);
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['controller'] = this.controller;
    data['address'] = this.address;
    if (this.room != null) {
      data['room'] = this.room.toMap();
    }
    data['state'] = this.state;
    return data;
  }

  Future<String> _state({String id, String controller}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // get controller ip
    http.Response response = await http.get("http://${prefs.getString("service.api-gateway")}:4000/$controller/devices/$id");

    print(response.body);

    if (response.statusCode != 200 && response.statusCode != 404)
      return "?";
    else if (response.statusCode == 404) return "Controller Failure";

    return "On";
  }
}

class Room {
  String id;
  String name;

  Room({this.id, this.name});

  Room.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
