import 'package:home/network/models/property.dart';
import 'package:json_annotation/json_annotation.dart' show JsonSerializable, JsonKey;

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

  /// The device's resp. controller.
  @JsonKey(name: 'controller')
  final String controller;

  /// Defines the device the given [property]
  /// is supposed to be executed on.
  @JsonKey(name: 'device')
  final String device;

  /// Defines a [property] consisting of a
  /// name, e.g. 'power' and a value,
  /// e.g. true.
  @JsonKey(name: 'property')
  final Property property;

  /// Serializes this object to a JSON primitive.
  Map<String, dynamic> toJson() => _$ActionToJson(this);

  @override
  String toString() {
    final buf = StringBuffer()
      ..write('$runtimeType(')
      ..write(', controller: $controller')
      ..write(', device: $device')
      ..write(', property: ${property}')
      ..write(')');
    return buf.toString();
  }
}
