import 'package:json_annotation/json_annotation.dart' show JsonSerializable, JsonKey;

import 'package:home/network/models/action.dart';

part 'scene.g.dart';

/// A [Scene] defines a set of executable [Actions]
@JsonSerializable()
class Scene {
  Scene({this.id, this.name, this.owner, this.actions});

  factory Scene.fromJson(Map<String, dynamic> json) => _$SceneFromJson(json);
  Map<String, dynamic> toJson() => _$SceneToJson(this);

  /// This defines the scenes identifier
  /// and is required to be unique.
  /// This value shoud not be set by the user.
  @JsonKey(name: 'id')
  String id;

  /// The human-readable name of the [Scene]
  @JsonKey(name: 'name', defaultValue: '')
  String name;

  /// Owner of the [Scene] is, whoever first created it.
  /// Must be a username registered with the core.user service.
  @JsonKey(name: 'owner', defaultValue: '')
  String owner;

  /// actions defines a [List] of executable [Actions]
  @JsonKey(name: 'actions')
  List<Action> actions;

  @override
  String toString() {
    return 'Scene(name: $name, actions: $actions, id: $id, owner: $owner)';
  }
}
