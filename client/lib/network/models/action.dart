import 'package:json_annotation/json_annotation.dart' show JsonSerializable, JsonKey;

// part 'action.g.dart';

/// An [Action] defines one step in a [Scene]
@JsonSerializable()
class Action {
  Action({this.controller, this.device, this.property});

  // factory Action.fromJson(Map<String, dynamic> json) => _$ActionFromJson(json);
  // Map<String, dynamic> toJson() => _$ActionToJson(this);

  /// The device's resp. controller
  @JsonKey(name: 'controller')
  String controller;

  /// Defines the device, the given [property]
  /// is supposed to be executed on
  @JsonKey(name: 'device')
  String device;

  /// Defines a [property] consisting of a
  /// name, e.g. 'power' and a value,
  /// e.g. true
  @JsonKey(name: 'property')
  Map<String, dynamic> property;
}
