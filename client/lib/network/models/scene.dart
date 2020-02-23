import 'package:json_annotation/json_annotation.dart' show JsonSerializable, JsonKey;

import 'package:home/network/models/action.dart';

part 'scene.g.dart';

/// A [Scene] defines a set of executable [Actions]
@JsonSerializable()
class Scene {
  /// Creates a new [Scene].
  const Scene({
    this.id,
    this.name,
    this.owner,
    this.actions,
  });

  /// Create a new [Scene] object from its JSON representation.
  factory Scene.fromJson(Map<String, dynamic> json) => _$SceneFromJson(json);

  /// This defines the scenes identifier
  /// and is required to be unique.
  /// This value shoud not be set by the user.
  @JsonKey(name: 'id')
  final String id;

  /// The human-readable name of the [Scene]
  @JsonKey(name: 'name', defaultValue: '')
  final String name;

  /// Owner of the [Scene] is, whoever first created it.
  /// Must be a username registered with the core.user service.
  @JsonKey(name: 'owner', defaultValue: '')
  final String owner;

  /// Actions defines a [List] of executable [Actions]
  @JsonKey(name: 'actions')
  final List<Action> actions;

  /// Serializes this object to a JSON primitive.
  Map<String, dynamic> toJson() => _$SceneToJson(this);

  @override
  String toString() {
    final buf = StringBuffer()
      ..write('$runtimeType(')
      ..write('id: $id')
      ..write(', name: $name')
      ..write(', owner: $owner')
      ..write(', actions: $actions')
      ..write(')');
    return buf.toString();
  }
}
