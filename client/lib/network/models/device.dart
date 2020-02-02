import 'package:json_annotation/json_annotation.dart' show JsonSerializable, JsonKey;

import 'package:home/network/models/state.dart';
import 'package:home/network/models/room.dart';

part 'device.g.dart';

@JsonSerializable()
class Device {
  Device({this.id, this.name, this.type, this.controller, this.address, this.room});

  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceToJson(this);

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'name', defaultValue: '')
  String name;

  @JsonKey(name: 'type')
  String type;

  @JsonKey(name: 'controller')
  String controller;

  @JsonKey(name: 'address')
  String address;

  @JsonKey(name: 'room')
  Room room;

  @JsonKey(name: 'state')
  DeviceState state;
}
