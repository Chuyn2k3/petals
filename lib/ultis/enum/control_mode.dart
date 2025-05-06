enum ControlMode {
  auto,
  manual,
  mimic,
  double1,
  blink,
}

extension ControlModeExtension on ControlMode {
  String get display {
    switch (this) {
      case ControlMode.auto:
        return 'Auto';
      case ControlMode.manual:
        return 'Manual';
      case ControlMode.mimic:
        return 'Mimic';
      case ControlMode.double1:
        return 'Double-1';
      case ControlMode.blink:
        return "Blink";
    }
  }

  int get value => index;
  static ControlMode? fromString(String str) {
    return ControlMode.values.firstWhere(
      (e) => e.display.toLowerCase() == str.toLowerCase(),
      orElse: () => ControlMode.auto,
    );
  }
}
