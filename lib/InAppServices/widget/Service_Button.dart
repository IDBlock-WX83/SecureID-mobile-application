import 'package:flutter/material.dart';

class ServiceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final double iconSize;
  final double fontSize;
  final Color cardColor;
  final Color textColor;
  final VoidCallback onPressed;

  const ServiceButton({
    Key? key,
    required this.icon,
    required this.label,
    this.iconSize = 50.0,
    this.fontSize = 16.0,
    this.cardColor = const Color(0xFF00BBC9),
    this.textColor = Colors.black,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: cardColor,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: iconSize),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(fontSize: fontSize, color: textColor),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
