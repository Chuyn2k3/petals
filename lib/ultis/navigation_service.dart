
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class NavigationService {
  final navigatorKey = GlobalKey<NavigatorState>();
BuildContext? get navigatorContext => navigatorKey.currentState?.context;

}

BuildContext get getContext {
  final context = GetIt.instance<NavigationService>().navigatorContext;
  if (context == null) {
    throw Exception('Navigator context is not available yet. Ensure UI is initialized.');
  }
  return context;
}

