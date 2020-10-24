import 'package:home/src/network/models/property.dart';
import 'package:json_annotation/json_annotation.dart'
    show JsonSerializable, JsonKey;

part 'action.g.dart';

/// An [Action] defines one step in a [Scene].
@JsonSerializable()
class Action {
  /// Creates a new [Action].
  const Action({
    this.controller,
    this.device,
    this.property,
  });

  /// Create a new [Action] object from its JSON representation.
  factory Action.fromJson(Map<String, dynamic> json) => _$ActionFromJson(json);

  /// A controller responsible for controlling the [device].
  @JsonKey(name: 'controller')
  final String controller;

  /// Defines the device the [property] executed on.
  @JsonKey(name: 'device')
  final String device;

  /// Defines a new [Property] instance.
  @JsonKey(name: 'property')
  final Property property;

  /// Serializes this object to a JSON primitive.
  Map<String, dynamic> toJson() => _$ActionToJson(this);

  @override
  String toString() {
    final buf = StringBuffer()
      ..write('$runtimeType(')
      ..write('controller: $controller')
      ..write(', device: $device')
      ..write(', property: $property')
      ..write(')');
    return buf.toString();
  }
}
