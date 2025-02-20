import 'package:flutter/material.dart';
import 'package:le_spawn_fr/core/constant/font.constant.dart';

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
        inputDecorationTheme: InputDecorationTheme(
          focusColor: primaryText,
          filled: true,
          fillColor: Colors.white,
          hintStyle: const TextStyle(color: Colors.black54),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryText, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: error, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: error, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          labelStyle: TextStyle(color: Colors.grey),
          floatingLabelStyle: TextStyle(color: primaryText),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: primaryText,
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(
            color: primaryBackground,
            fontSize: 24,
            fontFamily: FontConstant.grobold,
            letterSpacing: 1,
            shadows: [
              const Shadow(
                color: Colors.black,
                offset: Offset(2, 3),
              ),
            ],
          ),
        ),
        colorScheme: const ColorScheme.light(
          primary: accentRed,
          secondary: secondaryText,
          error: error,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
          ),
        ),
      );
}
