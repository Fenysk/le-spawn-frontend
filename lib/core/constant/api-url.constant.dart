import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiUrlConstant {
  static String get baseUrl => dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000';

  // Auth
  static String get register => '$baseUrl/auth/register';
  static String get login => '$baseUrl/auth/login';
  static String get logout => '$baseUrl/auth/logout';
  static String get refresh => '$baseUrl/auth/refresh';
  static String get googleLoginFromApp => '$baseUrl/auth/google/login-from-app';

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

  // GameItems
  static String get deleteGameItem => '$baseUrl/collections/games';

  // GamesBank
  static String get searchGamesInBank => '$baseUrl/bank/games/search';
  static String get searchGamesInProviders => '$baseUrl/bank/games/providers';
  static String get searchGamesFromBarcode => '$baseUrl/bank/games/barcode';
  static String get addBarcodeToGame => '$baseUrl/bank/games/barcode';

  // New Item
  static String get addGameToCollection => '$baseUrl/collections/games';
  static String get searchGamesFromImages => '$baseUrl/bank/games/images';
  static String get addGameFromCover => '$baseUrl/bank/games/cover';

  // Reports
  static String get createGameReport => '$baseUrl/game-reports';
  static String get getGameReports => '$baseUrl/game-reports/game';
  static String get getMyReports => '$baseUrl/game-reports/user';
  static String get updateReportStatus => '$baseUrl/game-reports';

  // Storage
  static String get uploadFile => '$baseUrl/storage/upload';
  static String get deleteFile => '$baseUrl/storage/delete';
}
