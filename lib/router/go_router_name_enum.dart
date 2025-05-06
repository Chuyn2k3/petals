enum GoRouterName {
  launch,
  mainMenu,
  modeSelection,
  scanningMaster,
  lightMode,
  setting,
  test,
}

extension GoRouterNameX on GoRouterName {
  String get routeName => name;

  String get routePath {
    switch (this) {
      case GoRouterName.launch:
        return "/";
      case GoRouterName.mainMenu:
        return "/main-menu";
      case GoRouterName.modeSelection:
        return "/mode-selection";
      case GoRouterName.scanningMaster:
        return "/scanning-master";
      case GoRouterName.lightMode:
        return "/light-mode";
      case GoRouterName.setting:
        return "/setting";
      case GoRouterName.test:
        return "/test";
    }
  }
}
