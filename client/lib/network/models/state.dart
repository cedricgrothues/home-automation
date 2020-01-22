import 'package:json_annotation/json_annotation.dart';

import 'package:home/network/models/ranged.dart';

part 'state.g.dart';

@JsonSerializable()
class DeviceState {
  @JsonKey(includeIfNull: false, defaultValue: false)
  bool power;

  @JsonKey(includeIfNull: false)
  RangedValue brightness;

  @JsonKey(name: "color_mode", includeIfNull: false)
  String colorMode;

  @JsonKey(includeIfNull: false)
  RangedValue temperature;

  @JsonKey(includeIfNull: false)
  RangedValue hue;

  @JsonKey(includeIfNull: false)
  RangedValue saturation;

  @JsonKey(defaultValue: false)
  bool error = false;

  DeviceState(
      {this.power, this.brightness, this.colorMode, this.hue, this.saturation, this.temperature, this.error = false});

  factory DeviceState.fromJson(Map<String, dynamic> json) => _$DeviceStateFromJson(json);
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
}
