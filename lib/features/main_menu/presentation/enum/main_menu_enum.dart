import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:petals/router/go_router_name_enum.dart';
import 'package:petals/ultis/navigation_service.dart';

enum MainMenu {
  mode,
  setting,
  test,
  faq,
  ;

  String get display {
    switch (this) {
      case MainMenu.mode:
        return "MODE";
      case MainMenu.setting:
        return "SETTING";
      case MainMenu.test:
        return "TEST";
      case MainMenu.faq:
        return "FAQ";
    }
  }

  VoidCallback get onTap {
    switch (this) {
      case MainMenu.mode:
        return () {
          getContext.pushNamed(GoRouterName.modeSelection.routeName);
        };
      case MainMenu.setting:
        return () {
          getContext.pushNamed(GoRouterName.setting.routeName);
        };
      case MainMenu.test:
        return () {
          getContext.pushNamed(GoRouterName.test.routeName);
        };
      case MainMenu.faq:
        return () {};
    }
  }

  String get imageAsset {
    return "assets/images/$name.png";
  }

  IconData get icon {
    switch (this) {
      case MainMenu.mode:
        return FontAwesomeIcons.layerGroup;
      case MainMenu.setting:
        return FontAwesomeIcons.gear;
      case MainMenu.test:
        return FontAwesomeIcons.shareNodes;
      case MainMenu.faq:
        return FontAwesomeIcons.circleQuestion;
    }
  }

  Color get color {
    switch (this) {
      case MainMenu.mode:
        return Colors.pinkAccent;
      case MainMenu.setting:
        return const Color(0xFF5DA6C7);
      case MainMenu.test:
        return Colors.deepOrangeAccent;
      case MainMenu.faq:
        return Colors.amberAccent.shade700;
    }
  }
}
