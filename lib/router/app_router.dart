import 'package:flutter/material.dart';
import 'package:petals/features/main_menu/presentation/main_menu_screen.dart';
import 'package:petals/features/mode_selection/presentation/mode_selection_screen.dart';
import 'package:petals/features/setting/presentation/setting_screen.dart';
import 'package:petals/features/test/presentation/test_screen.dart';
import 'package:petals/router/go_router_name_enum.dart';
import 'package:petals/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:petals/ultis/navigation_service.dart';
class AppRouter {
  late final GoRouter router = GoRouter(
    navigatorKey: GetIt.instance<NavigationService>().navigatorKey,
    routerNeglect: true,
    debugLogDiagnostics: true,
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text("Page not found"))),
    routes: <GoRoute>[
      GoRoute(
        path: GoRouterName.launch.routePath,
        name: GoRouterName.launch.routeName,
        builder: (context, state) => const LaunchScreen(),
      ),
      GoRoute(
        path: GoRouterName.mainMenu.routePath,
        name: GoRouterName.mainMenu.routeName,
        builder: (context, state) => const MainMenuScreen(),
      ),
      GoRoute(
        path: GoRouterName.modeSelection.routePath,
        name: GoRouterName.modeSelection.routeName,
        builder: (context, state) => const ModeSelectionScreen(),
      ),
      // GoRoute(
      //   path: GoRouterName.scanningMaster.routePath,
      //   name: GoRouterName.scanningMaster.routeName,
      //   builder: (context, state) => const ScanningMasterScreen(),
      // ),
      // GoRoute(
      //   path: GoRouterName.lightMode.routePath,
      //   name: GoRouterName.lightMode.routeName,
      //   builder: (context, state) => const LightModeScreen(),
      // ),
      GoRoute(
        path: GoRouterName.setting.routePath,
        name: GoRouterName.setting.routeName,
        builder: (context, state) => const SettingScreen(),
      ),
      GoRoute(
        path: GoRouterName.test.routePath,
        name: GoRouterName.test.routeName,
        builder: (context, state) => const TestScreen(),
      ),
    ],
  );
}

