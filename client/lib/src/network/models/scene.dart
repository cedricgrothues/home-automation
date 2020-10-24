import 'package:json_annotation/json_annotation.dart'
    show JsonSerializable, JsonKey;

import 'package:home/src/network/models/action.dart';

part 'scene.g.dart';

/// A [Scene] defines a set of executable [Actions].
@JsonSerializable()
class Scene {
  /// Create a new [Scene].
  const Scene({
    this.id,
    this.name,
    this.owner,
    this.actions,
  });

  /// Create a new [Scene] object from its JSON representation.
  factory Scene.fromJson(Map<String, dynamic> json) => _$SceneFromJson(json);

  /// Unique identifier for this [Scene].
  /// This value shoud not be set by the user.
  @JsonKey(name: 'id')
  final String id;

  /// The human-readable non-unique name of this [Scene].
  @JsonKey(name: 'name', defaultValue: '')
  final String name;

  /// Owner of the [Scene] is, whoever first created it.
  /// Must be a username from a registered user.
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
