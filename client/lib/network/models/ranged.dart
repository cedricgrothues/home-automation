import 'package:json_annotation/json_annotation.dart' show JsonSerializable, JsonKey;

part 'ranged.g.dart';

@JsonSerializable()
class RangedValue {
  /// Creates a new [RangedValue].
  const RangedValue({
    this.min,
    this.max,
    this.value,
  });

  /// Create a new [RangedValue] object from its JSON representation.
  factory RangedValue.fromJson(Map<String, dynamic> json) => _$RangedValueFromJson(json);

  /// Minimum value of this [RangedValue]
  @JsonKey(name: 'min')
  final int min;

  /// Maximum value of this [RangedValue]
  @JsonKey(name: 'max')
  final int max;

  /// Current value of this [RangedValue]
  @JsonKey(name: 'value')
  final int value;

  /// Serializes this object to a JSON primitive.
  Map<String, dynamic> toJson() => _$RangedValueToJson(this);

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

  @override
  String toString() {
    final buf = StringBuffer()
      ..write('$runtimeType(')
      ..write('value: $value')
      ..write(', min: $min')
      ..write(', max: $max')
      ..write(')');
    return buf.toString();
  }
}
