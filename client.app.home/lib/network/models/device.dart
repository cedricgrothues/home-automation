import 'package:json_annotation/json_annotation.dart';

import 'package:home/network/models/room.dart';

part 'device.g.dart';

@JsonSerializable()
class Device {
  @JsonKey(name: "id")
  String id;

  @JsonKey(name: "name")
  String name;

  @JsonKey(name: "type")
  String type;

  @JsonKey(name: "controller")
  String controller;

  @JsonKey(name: "address")
  String address;

  @JsonKey(name: "room")
  Room room;

  @JsonKey(name: "state")
  Map<String, dynamic> state;

  Device({this.id, this.name, this.type, this.controller, this.address, this.room});

  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceToJson(this);
}
