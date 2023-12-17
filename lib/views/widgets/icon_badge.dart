import 'package:flutter/material.dart';

class BadgeIcon extends StatelessWidget {
  const BadgeIcon({super.key, required this.badgeText});
  final String badgeText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 1),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.red.shade500,
        border: Border.all(color: Colors.white),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: FittedBox(
          child: Text(
            badgeText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
            ),
          ),
        ),
      ),
    );
  }
}
