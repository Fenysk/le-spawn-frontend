import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io' show Platform;

class ApiUrlConstant {
  static String get baseUrl {
    if (Platform.isWindows) {
      return dotenv.env['API_BASE_URL_WINDOWS'] ?? 'http://localhost:3000';
    } else if (Platform.isAndroid) {
      return dotenv.env['API_BASE_URL_ANDROID'] ?? 'http://10.0.2.2:3000';
    } else {
      return dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000';
    }
  }

  // Auth
  static String get register => '$baseUrl/auth/register';
  static String get login => '$baseUrl/auth/login';
  static String get logout => '$baseUrl/auth/logout';
  static String get refresh => '$baseUrl/auth/refresh';

  // Users
  static String get getMyProfile => '$baseUrl/users/my-profile';
  static String get getUserProfile => '$baseUrl/users/profile';
  static String get checkIfPseudoExist => '$baseUrl/users/check-pseudo';
}
