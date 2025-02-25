import 'package:le_spawn_fr/features/auth/2_domain/repository/auth.repository.dart';
import 'package:le_spawn_fr/service-locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

abstract class AuthLocalService {
  Future<bool> isLoggedIn();
  Future<String> getAccessToken();
  Future<String> getRefreshToken();
  Future<void> setAccessToken(String newAccessToken);
  Future<void> setRefreshToken(String newRefreshToken);
  Future<void> clearTokens();
}

class AuthLocalServiceImpl extends AuthLocalService {
  @override
  Future<bool> isLoggedIn() async {
    String accessToken;

    try {
      accessToken = await getAccessToken();
    } catch (e) {
      return false;
    }

    try {
      final isNotExpired = !JwtDecoder.isExpired(accessToken);

      if (!isNotExpired) {
        await serviceLocator<AuthRepository>().refresh();

        accessToken = await getAccessToken();

        final isNotExpiredAfterRefresh = !JwtDecoder.isExpired(accessToken);

        return isNotExpiredAfterRefresh;
      }

      return isNotExpired;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String> getAccessToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final accessToken = sharedPreferences.getString('accessToken');

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('Access token is empty');
    }

    return accessToken;
  }

  @override
  Future<String> getRefreshToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final refreshToken = sharedPreferences.getString('refreshToken');

    if (refreshToken == null || refreshToken.isEmpty) {
      throw Exception('Refresh token is empty');
    }

    return refreshToken;
  }

  @override
  Future<void> setAccessToken(String newAccessToken) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString('accessToken', newAccessToken);
  }

  @override
  Future<void> setRefreshToken(String newRefreshToken) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString('refreshToken', newRefreshToken);
  }

  @override
  Future<void> clearTokens() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('accessToken');
    sharedPreferences.remove('refreshToken');
  }
}
