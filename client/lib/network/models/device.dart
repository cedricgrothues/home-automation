import 'package:json_annotation/json_annotation.dart' show JsonSerializable, JsonKey;

import 'package:home/network/models/state.dart';
import 'package:home/network/models/room.dart';

part 'device.g.dart';

/// A [Device] is a representaion of a physical device,
/// stored in `core.device-registry`.
@JsonSerializable()
class Device {
  /// Creates a new [Device].
  Device({
    this.id,
    this.name,
    this.type,
    this.controller,
    this.address,
    this.room,
    this.state,
  });

  /// Create a new [Device] object from its JSON representation.
  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);

  /// Unique identifier for the device itself.
  @JsonKey(name: 'id')
  String id;

  /// The human-readable non-unique identifier of the device.
  @JsonKey(name: 'name', defaultValue: '')
  String name;

  /// The type of device (e.g. "lamp-dimmable").
  @JsonKey(name: 'type')
  String type;

  /// Identifier of the device's controller (e.g. "modules.sonos").
  @JsonKey(name: 'controller')
  String controller;

  /// Unique a IPv4 address of the device.
  @JsonKey(name: 'address')
  String address;

  /// Information about the device's room.
  @JsonKey(name: 'room')
  Room room;

  /// Information about the device's state.
  @JsonKey(name: 'state')
  DeviceState state;

  /// Serializes this object to a JSON primitive.
  Map<String, dynamic> toJson() => _$DeviceToJson(this);

  @override
  String toString() {
    final buf = StringBuffer()
      ..write('$runtimeType(')
      ..write('id: $id')
      ..write(', name: $name')
      ..write(', type: $type')
      ..write(', controller: $controller')
      ..write(', address: $address')
      ..write(', room: ${room?.id}')
      ..write(', state: $state')
      ..write(')');
    return buf.toString();
  }
}
