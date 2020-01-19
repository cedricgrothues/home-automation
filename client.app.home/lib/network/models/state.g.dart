// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceState _$DeviceStateFromJson(Map<String, dynamic> json) {
  return DeviceState(
    power: json['power'] as bool ?? false,
    brightness: json['brightness'] == null
        ? null
        : RangedValue.fromJson(json['brightness'] as Map<String, dynamic>),
    colorMode: json['color_mode'] as String,
    hue: json['hue'] == null
        ? null
        : RangedValue.fromJson(json['hue'] as Map<String, dynamic>),
    saturation: json['saturation'] == null
        ? null
        : RangedValue.fromJson(json['saturation'] as Map<String, dynamic>),
    temperature: json['temperature'] == null
        ? null
        : RangedValue.fromJson(json['temperature'] as Map<String, dynamic>),
    error: json['error'] as bool ?? false,
  );
}

Map<String, dynamic> _$DeviceStateToJson(DeviceState instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('power', instance.power);
  writeNotNull('brightness', instance.brightness);
  writeNotNull('color_mode', instance.colorMode);
  writeNotNull('temperature', instance.temperature);
  writeNotNull('hue', instance.hue);
  writeNotNull('saturation', instance.saturation);
  val['error'] = instance.error;
  return val;
}
