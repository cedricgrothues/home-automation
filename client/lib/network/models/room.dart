import 'package:json_annotation/json_annotation.dart' show JsonSerializable, JsonKey;

part 'room.g.dart';

@JsonSerializable()
class Room {
  /// Creates a new [Room].
  const Room({
    this.id,
    this.name,
  });

  /// Create a new [Room] object from its JSON representation.
  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

  /// Unique ID of this [Room]
  @JsonKey(name: 'id', defaultValue: '')
  final String id;

  /// Human-readable name of this [Room]
  @JsonKey(name: 'name', defaultValue: '')
  final String name;

  /// Serializes this object to a JSON primitive.
  Map<String, dynamic> toJson() => _$RoomToJson(this);

  @override
  String toString() {
    final buf = StringBuffer()
      ..write('$runtimeType(')
      ..write('id: $id')
      ..write(', name: $name')
      ..write(
        ')',
      );
    return buf.toString();
  }
}
