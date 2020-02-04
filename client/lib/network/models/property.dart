import 'package:json_annotation/json_annotation.dart' show JsonSerializable, JsonKey;

part 'property.g.dart';

/// [Property] defines a key, value pair in an [Action]
@JsonSerializable()
class Property {
  Property({this.name, this.value});

  factory Property.fromJson(Map<String, dynamic> json) => _$PropertyFromJson(json);
  Map<String, dynamic> toJson() => _$PropertyToJson(this);

  /// Property name
  @JsonKey(name: 'name')
  String name;

  /// Property value
  @JsonKey(name: 'value')
  dynamic value;

  @override
  String toString() {
    return 'Property(name: $name, value: $value)';
  }
}
