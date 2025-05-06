import 'package:get_it/get_it.dart';
import 'package:petals/ultis/navigation_service.dart';
import 'package:petals/ultis/shared_preferences_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt serviceLocator = GetIt.instance;

Future<void> setupLocator() async {
  //serviceLocator
  serviceLocator.registerLazySingleton(() => NavigationService());
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(
      () => SharedPreferencesManager(sharedPreferences: sharedPreferences));
}