import 'package:json_annotation/json_annotation.dart';

part 'ranged.g.dart';

@JsonSerializable()
class RangedValue {
  RangedValue({this.min, this.max, this.value});

  factory RangedValue.fromJson(Map<String, dynamic> json) => _$RangedValueFromJson(json);
  Map<String, dynamic> toJson() => _$RangedValueToJson(this);

  @JsonKey(name: 'min')
  int min;

  @JsonKey(name: 'max')
  int max;

  @JsonKey(name: 'value')
  int value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RangedValue &&
          runtimeType == other.runtimeType &&
          min == other.min &&
          max == other.max &&
          value == other.value;

  @override
  int get hashCode => min.hashCode ^ max.hashCode ^ value.hashCode;
}
