import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiUrlConstant {
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000';

  // Auth
  static String get register => '$baseUrl/auth/register';
  static String get login => '$baseUrl/auth/login';
  static String get logout => '$baseUrl/auth/logout';
  static String get refresh => '$baseUrl/auth/refresh';

  // Users
  static String get getMyProfile => '$baseUrl/users/my-profile';
  static String get getUserProfile => '$baseUrl/users/profile';
  static String get checkIfPseudoExist => '$baseUrl/users/check-pseudo';

  // Collections
  static String get getMyCollections => '$baseUrl/collections';
  static String get getCollectionById => '$baseUrl/collections';
  static String get createCollection => '$baseUrl/collections';
  static String get updateCollection => '$baseUrl/collections';
  static String get deleteCollection => '$baseUrl/collections';

  // GamesBank
  static String get getGameFromBarcode => '$baseUrl/games/barcode';

  // New Item
  static String get addGameToCollection => '$baseUrl/collections/games';
}
