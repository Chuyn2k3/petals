import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:petals/features/main_menu/presentation/main_menu_screen.dart';

class BaseScaffold extends StatelessWidget {
  final Widget? child;
  final Widget? message;
  final VoidCallback? onHomePressed;
  final VoidCallback? onNextPressed;
  final bool isHomeButton;
  final bool isMessage;
  final bool isNextButton;

  const BaseScaffold({
    super.key,
    this.child,
    this.message,
    this.onHomePressed,
    this.onNextPressed,
    this.isHomeButton = true,
    this.isMessage = false,
    this.isNextButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          if (child != null) Expanded(child: child!),
          Container(
            //  color: Colors.black87,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (isHomeButton == true)
                  CustomIconButton(
                    icon: FontAwesomeIcons.house,
                    label: "Home",
                    backgroundColor: Colors.pinkAccent,
                    onPressed: onHomePressed ??
                        () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainMenuScreen(),
                              ));
                        },
                  ),
                if (isMessage == true && message != null) ...[
                  message!
                ] else ...[
                  const Spacer()
                ],
                if (isNextButton == true)
                  CustomIconButton(
                    icon: FontAwesomeIcons.play, // icon kiểu "tiếp tục"
                    label: "Next",
                    backgroundColor: Colors.green,
                    onPressed: onNextPressed ?? () {},
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            FaIcon(icon, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}
