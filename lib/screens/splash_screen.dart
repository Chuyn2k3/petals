import 'package:flutter/material.dart';
import 'package:petals/constant/config.dart';
import 'package:petals/features/main_menu/presentation/main_menu_screen.dart';
import 'package:petals/widget/app_spacer.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return const MainMenuScreen();
            },
          ),
        ); // Chuyển hướng sau khi kết thúc splash
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(vertical: context.screenSize.height * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Giãn cách đều
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: context.screenSize.height * 0.5,
                child: ClipRRect(
                  child: Image.asset(
                    "assets/images/logo.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              AppSpacer.p12(),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: double.infinity,
                child: const Text(
                  "PETALS",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              AppSpacer.p12(),
              const SizedBox(
                width: double.infinity,
                child: Text(
                  "Portable Electronic Traffic Assistance Light System",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
