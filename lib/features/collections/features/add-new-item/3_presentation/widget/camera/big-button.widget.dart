import 'package:flutter/material.dart';

enum ButtonType {
  primary,
  secondary
}

class BigButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final IconData icon;
  final ButtonType type;

  const BigButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.icon,
    this.type = ButtonType.secondary,
  });

  @override
  Widget build(BuildContext context) {
    final isPrimary = type == ButtonType.primary;
    return Container(
      decoration: BoxDecoration(
        color: isPrimary ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isPrimary ? Colors.white : Colors.black,
          width: 2,
        ),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isPrimary ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              icon,
              color: isPrimary ? Colors.white : Colors.black,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
