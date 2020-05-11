import 'package:json_annotation/json_annotation.dart' show JsonSerializable, JsonKey;

part 'property.g.dart';

/// [Property] defines a key, value pair in an [Action]
@JsonSerializable()
class Property {
  /// Creates a new [Property].
  const Property({
    this.name,
    this.value,
  });

  /// Create a new [Property] object from its JSON representation.
  factory Property.fromJson(Map<String, dynamic> json) => _$PropertyFromJson(json);

  /// Human-readable name of the [Property]
  @JsonKey(name: 'name')
  final String name;

  /// Value of the [Property]
  @JsonKey(name: 'value')
  final dynamic value;

  /// Serializes this object to a JSON primitive.
  Map<String, dynamic> toJson() => _$PropertyToJson(this);

  @override
  String toString() {
    final buf = StringBuffer()
      ..write('$runtimeType(')
      ..write('name: $name')
      ..write(', value: $value')
      ..write(
        ')',
      );
    return buf.toString();
  }
}
