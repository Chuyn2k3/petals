import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:petals/di/locator.dart';
import 'package:petals/router/app_router.dart';
import 'package:petals/ultis/navigation_service.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  // await MqttService().connect();
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.landscapeLeft,
  //   DeviceOrientation.landscapeRight,
  // ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GetIt.instance<NavigationService>().navigatorKey;
  @override
  Widget build(BuildContext context) {
    final AppRouter appRouter = AppRouter();
    return ToastificationWrapper(
      child: MaterialApp.router(
        theme: ThemeData(
            fontFamily: 'InstrumentSans',
            useMaterial3: false,
            appBarTheme: const AppBarTheme(
              elevation: 1,
              centerTitle: true,
              backgroundColor: Color.fromARGB(255, 129, 123, 123),
              iconTheme: IconThemeData(color: Colors.blue),
              titleTextStyle: TextStyle(
                  color: Colors.blue, fontSize: 20, fontWeight: FontWeight.w500),
            )),
        routerConfig: appRouter.router, // Sử dụng GoRouter ở đây
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
