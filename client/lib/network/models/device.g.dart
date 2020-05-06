// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Device _$DeviceFromJson(Map<String, dynamic> json) {
  return Device(
    id: json['id'] as String,
    name: json['name'] as String ?? '',
    type: json['type'] as String,
    controller: json['controller'] as String,
    address: json['address'] as String,
    room: json['room'] == null ? null : Room.fromJson(json['room'] as Map<String, dynamic>),
    state: json['state'] == null ? null : DeviceState.fromJson(json['state'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$DeviceToJson(Device instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'controller': instance.controller,
      'address': instance.address,
      'room': instance.room,
      'state': instance.state,
    };
