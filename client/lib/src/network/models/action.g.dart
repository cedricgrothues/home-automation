// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Action _$ActionFromJson(Map<String, dynamic> json) {
  return Action(
    controller: json['controller'] as String,
    device: json['device'] as String,
    property: json['property'] == null ? null : Property.fromJson(json['property'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ActionToJson(Action instance) => <String, dynamic>{
      'controller': instance.controller,
      'device': instance.device,
      'property': instance.property,
    };
