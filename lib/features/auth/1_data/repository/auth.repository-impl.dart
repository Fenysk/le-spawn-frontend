import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:le_spawn_fr/features/auth/1_data/dto/login.request.dart';
import 'package:le_spawn_fr/features/auth/1_data/dto/register.request.dart';
import 'package:le_spawn_fr/features/auth/1_data/source/auth-api.service.dart';
import 'package:le_spawn_fr/features/auth/1_data/source/auth-local.service.dart';
import 'package:le_spawn_fr/features/auth/2_domain/repository/auth.repository.dart';
import 'package:le_spawn_fr/features/user/1_data/model/user.model.dart';
import 'package:le_spawn_fr/features/user/1_data/source/user-local.service.dart';
import 'package:le_spawn_fr/features/user/2_domain/entity/user.entity.dart';
import 'package:le_spawn_fr/service-locator.dart';

class AuthenticatedDataResponse {
  final String accessToken;
  final String refreshToken;
  final bool isFirstTime;
  final UserEntity user;

  AuthenticatedDataResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.isFirstTime,
    required this.user,
  });
}

class AuthRepositoryImpl extends AuthRepository {
  Future<Either<String, AuthenticatedDataResponse>> _handleAuthResponse(Response response) async {
    final accessToken = response.data['tokens']['accessToken'];
    final refreshToken = response.data['tokens']['refreshToken'];
    final user = response.data['user'];
    final isFirstTime = response.data['isFirstTime'] as bool;

    if (accessToken != null) await serviceLocator<AuthLocalService>().setAccessToken(accessToken);
    if (refreshToken != null) await serviceLocator<AuthLocalService>().setRefreshToken(refreshToken);

    final userModel = UserModel.fromMap(user);
    if (user != null) await serviceLocator<UserLocalService>().setCurrentUser(userModel);

    return Right(AuthenticatedDataResponse(
      accessToken: accessToken,
      refreshToken: refreshToken,
      isFirstTime: isFirstTime,
      user: userModel.toEntity(),
    ));
  }

  @override
  Future<bool> isLoggedIn() async {
    return await serviceLocator<AuthLocalService>().isLoggedIn();
  }

  @override
  Future<Either<String, AuthenticatedDataResponse>> register(RegisterRequest registerRequest) async {
    Either result = await serviceLocator<AuthApiService>().register(registerRequest);

    return result.fold(
      (error) => Left(error),
      (data) => _handleAuthResponse(data),
    );
  }

  @override
  Future<Either<String, AuthenticatedDataResponse>> login(LoginRequest loginRequest) async {
    Either<String, dynamic> result = await serviceLocator<AuthApiService>().login(loginRequest);

    return result.fold(
      (error) => Left(error),
      (data) => _handleAuthResponse(data),
    );
  }

  @override
  Future<Either<String, void>> logout() async {
    Either result = await serviceLocator<AuthApiService>().logout();

    await serviceLocator<AuthLocalService>().clearTokens();

    return result.fold(
      (error) => Left(error),
      (data) => Right(null),
    );
  }

  @override
  Future<Either<String, AuthenticatedDataResponse>> refresh() async {
    final refreshToken = await serviceLocator<AuthLocalService>().getRefreshToken();

    Either result = await serviceLocator<AuthApiService>().refresh(refreshToken);

    return result.fold(
      (error) async {
        await serviceLocator<AuthLocalService>().clearTokens();
        return Left(error);
      },
      (data) => _handleAuthResponse(data),
    );
  }

  @override
  Future<Either<String, AuthenticatedDataResponse>> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await serviceLocator<AuthApiService>().signInWithGoogle();

      if (googleUser == null) {
        return Left('Sign-in aborted by user');
      }

      final response = await serviceLocator<AuthApiService>().googleLoginFromApp(googleUser);

      return response.fold(
        (error) => Left(error),
        (data) => _handleAuthResponse(data),
      );
    } catch (e) {
      return Left('Google Sign-In failed: ${e.toString()}');
    }
  }
}
