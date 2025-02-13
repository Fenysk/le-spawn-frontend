import 'package:flutter/material.dart';
import 'package:le_spawn_frontend/core/constant/font.constant.dart';

class AppTheme {
  static const Color primaryText = Colors.black;
  static const Color primaryBackground = Colors.white;

  static const Color secondaryText = Color(0xFF7F8C8D);
  static const Color secondaryBackground = Color(0xFFF5F6FA);

  static const Color accentRed = Color(0xFFF2413A);
  static const Color accentGreen = Color(0xFF06B487);
  static const Color accentYellow = Color(0xFFFDD000);

  static const Color error = Color.fromARGB(255, 165, 35, 42);

  static ThemeData get leSpawnTheme => ThemeData(
        primaryColor: accentRed,
        scaffoldBackgroundColor: primaryBackground,
        fontFamily: FontConstant.acephimere,
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontSize: 24,
            fontFamily: FontConstant.grobold,
            shadows: [
              Shadow(
                color: Colors.black,
                offset: const Offset(2, 3),
              ),
            ],
          ),
          bodyLarge: const TextStyle(color: primaryText),
          bodyMedium: const TextStyle(color: secondaryText),
        ),
        colorScheme: const ColorScheme.light(
          primary: accentRed,
          secondary: secondaryText,
          error: error,
        ),
      );
}
