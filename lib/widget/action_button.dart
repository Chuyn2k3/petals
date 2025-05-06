import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color buttonColor;
  final double padding;

  const ActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = const Color(0xFFD9D9D9),
    this.buttonColor = const Color(0xFF7B9AB7),
    this.padding = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: buttonColor,
                ),
              )
              //Icon(icon, color: Colors.blueGrey, size: iconSize),
              ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.black)),
      ],
    );
  }
}
