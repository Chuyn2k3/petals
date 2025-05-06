import 'package:petals/ultis/enum/control_mode.dart';

class SetModePayload {
  final ControlMode controlMode;
  final int? id;
  final int? redDuration;
  final int? greenDuration;
  final int? yellowDuration;
  final int? color;
  final int? linkedId;
  final int? blink_period;
  SetModePayload({
    required this.controlMode,
    this.id,
    this.redDuration,
    this.greenDuration,
    this.yellowDuration,
    this.color,
    this.linkedId,
    this.blink_period=2000,
  });

  Map<String, dynamic> toJson() {
    switch (controlMode) {
      case ControlMode.auto:
        return {
          "type": controlMode.value,
          "id": id,
          "red_duration": redDuration,
          "green_duration": greenDuration,
          "yellow_duration": yellowDuration,
        };
      case ControlMode.manual:
        return {
          "type": controlMode.value,
          "id": id,
          "color": color,
        };
      case ControlMode.mimic:
        return {
          "type": controlMode.value,
          "red_duration": redDuration,
          "green_duration": greenDuration,
          "yellow_duration": yellowDuration,
        };
      case ControlMode.double1:
        return {
          "type": controlMode.value,
          "linked_id": linkedId,
          "red_duration": redDuration,
          "green_duration": greenDuration,
          "yellow_duration": yellowDuration,
        };
      case ControlMode.blink:
        return {
          "type": controlMode.value,
          "blink_period": blink_period,
          "color": color,
        };
    }
  }

  Map<String, dynamic> wrap() {
    return {"SET_MODE": toJson()};
  }

  // Phương thức từ JSON để giải mã dữ liệu
  factory SetModePayload.fromJson(Map<String, dynamic> json) {
    final controlModeValue = json["SET_MODE"]["type"];
    final controlMode =
        ControlMode.values.firstWhere((e) => e.value == controlModeValue);

    switch (controlMode) {
      case ControlMode.auto:
        return SetModePayload(
          controlMode: controlMode,
          id: json["SET_MODE"]["id"],
          redDuration: json["SET_MODE"]["red_duration"],
          greenDuration: json["SET_MODE"]["green_duration"],
          yellowDuration: json["SET_MODE"]["yellow_duration"],
        );
      case ControlMode.manual:
        return SetModePayload(
          controlMode: controlMode,
          id: json["SET_MODE"]["id"],
          color: json["SET_MODE"]["color"],
        );
      case ControlMode.mimic:
        return SetModePayload(
          controlMode: controlMode,
          redDuration: json["SET_MODE"]["red_duration"],
          greenDuration: json["SET_MODE"]["green_duration"],
          yellowDuration: json["SET_MODE"]["yellow_duration"],
        );
      case ControlMode.double1:
        return SetModePayload(
          controlMode: controlMode,
          linkedId: json["SET_MODE"]["linked_id"],
          redDuration: json["SET_MODE"]["red_duration"],
          greenDuration: json["SET_MODE"]["green_duration"],
          yellowDuration: json["SET_MODE"]["yellow_duration"],
        );
      case ControlMode.blink:
        return SetModePayload(
          controlMode: controlMode,
          blink_period: json["SET_MODE"]["blink_period"],
          color: json["SET_MODE"]["color"],
        );
    }
  }
}
