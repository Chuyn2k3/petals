// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class AppConfig {
  AppConfig._();
}

extension GetOrientation on BuildContext {
  Orientation get orientation => MediaQuery.of(this).orientation;
}

extension GetSize on BuildContext {
  Size get screenSize => MediaQuery.sizeOf(this);
}
