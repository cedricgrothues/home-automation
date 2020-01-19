// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranged.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RangedValue _$RangedValueFromJson(Map<String, dynamic> json) {
  return RangedValue(
    min: json['min'] as int,
    max: json['max'] as int,
    value: json['value'] as int,
  );
}

Map<String, dynamic> _$RangedValueToJson(RangedValue instance) =>
    <String, dynamic>{
      'min': instance.min,
      'max': instance.max,
      'value': instance.value,
    };
