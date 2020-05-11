import 'package:json_annotation/json_annotation.dart'
    show JsonSerializable, JsonKey;

import 'package:home/src/network/models/ranged.dart';

part 'state.g.dart';

@JsonSerializable()
class DeviceState {
  /// Creates a new [DeviceState].
  DeviceState({
    this.power,
    this.brightness,
    this.colorMode,
    this.hue,
    this.saturation,
    this.temperature,
    this.error = false,
  });

  /// Create a new [DeviceState] object from its JSON representation.
  factory DeviceState.fromJson(Map<String, dynamic> json) =>
      _$DeviceStateFromJson(json);

  /// The Device's power state.
  @JsonKey(includeIfNull: false, defaultValue: false)
  bool power;

  /// The Device's brightness (e.g. min: 0, max: 100, value: 50).
  @JsonKey(includeIfNull: false)
  RangedValue brightness;

  /// The Device's color mode.
  @JsonKey(name: 'color_mode', includeIfNull: false)
  String colorMode;

  /// The Device's (color) temperature.
  @JsonKey(includeIfNull: false)
  RangedValue temperature;

  /// The Device's hue value.
  @JsonKey(includeIfNull: false)
  RangedValue hue;

  /// The Device's saturation value.
  @JsonKey(includeIfNull: false)
  RangedValue saturation;

  /// True the current [DeviceState] contains an error.
  @JsonKey(defaultValue: false)
  bool error = false;

  /// Serializes this object to a JSON primitive.
  Map<String, dynamic> toJson() => _$DeviceStateToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceState &&
          runtimeType == other.runtimeType &&
          power == other.power &&
          brightness == other.brightness &&
          colorMode == other.colorMode &&
          temperature == other.temperature &&
          hue == other.hue &&
          saturation == other.saturation &&
          error == other.error;

  @override
  int get hashCode =>
      power.hashCode ^
      brightness.hashCode ^
      colorMode.hashCode ^
      temperature.hashCode ^
      hue.hashCode ^
      saturation.hashCode ^
      error.hashCode;

  @override
  String toString() {
    final buf = StringBuffer()
      ..write('$runtimeType(')
      ..write('power: $power')
      ..write(', brightness: $brightness')
      ..write(', colorMode: $colorMode')
      ..write(', temperature: $temperature')
      ..write(', hue: $hue')
      ..write(', saturation: $saturation')
      ..write(', error: $error')
      ..write(')');
    return buf.toString();
  }
}
