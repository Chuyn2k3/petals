import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum LightNumer {
  one,
  two,
  three,
  four,
  ;

  String get display {
    switch (this) {
      case LightNumer.one:
        return "1";
      case LightNumer.two:
        return "2";
      case LightNumer.three:
        return "3";
      case LightNumer.four:
        return "4";
    }
  }

  VoidCallback get onTap {
    switch (this) {
      case LightNumer.one:
        return () {};
      case LightNumer.two:
        return () {};
      case LightNumer.three:
        return () {};
      case LightNumer.four:
        return () {};
    }
  }

  String get imageAsset {
    return "assets/images/$name.png";
  }

  IconData get icon {
    switch (this) {
      case LightNumer.one:
        return FontAwesomeIcons.layerGroup;
      case LightNumer.two:
        return FontAwesomeIcons.gear;
      case LightNumer.three:
        return FontAwesomeIcons.shareNodes;
      case LightNumer.four:
        return FontAwesomeIcons.circleQuestion;
    }
  }

  Color get color {
    switch (this) {
      case LightNumer.one:
        return Colors.pinkAccent;
      case LightNumer.two:
        return const Color(0xFF5DA6C7);
      case LightNumer.three:
        return Colors.deepOrangeAccent;
      case LightNumer.four:
        return Colors.amberAccent.shade700;
    }
  }
}
