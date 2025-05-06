enum TestMode {
  mimic,
  blink,
}

extension TestModeExtension on TestMode {
  String get display {
    switch (this) {
      case TestMode.mimic:
        return 'Mimic';
      case TestMode.blink:
        return 'Blink';
    }
  }

  static TestMode? fromString(String str) {
    return TestMode.values.firstWhere(
      (e) => e.display.toLowerCase() == str.toLowerCase(),
      orElse: () => TestMode.mimic,
    );
  }
}
