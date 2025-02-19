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

class AuthRepositoryImpl extends AuthRepository {
  Future<Either<String, UserEntity>> _handleAuthResponse(Response response) async {
    final accessToken = response.data['tokens']['accessToken'];
    final refreshToken = response.data['tokens']['refreshToken'];
    final user = response.data['user'];

    if (accessToken != null) await serviceLocator<AuthLocalService>().setAccessToken(accessToken);
    if (refreshToken != null) await serviceLocator<AuthLocalService>().setRefreshToken(refreshToken);

    final userModel = UserModel.fromMap(user);
    if (user != null) await serviceLocator<UserLocalService>().setCurrentUser(userModel);

    return Right(userModel.toEntity());
  }

  @override
  Future<bool> isLoggedIn() async {
    return await serviceLocator<AuthLocalService>().isLoggedIn();
  }

  @override
  Future<Either<String, UserEntity>> register(RegisterRequest registerRequest) async {
    Either result = await serviceLocator<AuthApiService>().register(registerRequest);

    return result.fold(
      (error) => Left(error),
      (data) => _handleAuthResponse(data),
    );
  }

  @override
  Future<Either<String, UserEntity>> login(LoginRequest loginRequest) async {
    Either<String, dynamic> result = await serviceLocator<AuthApiService>().login(loginRequest);

    return result.fold(
      (error) => Left(error),
      (data) => _handleAuthResponse(data),
    );
  }

  @override
  Future<Either> logout() async {
    Either result = await serviceLocator<AuthApiService>().logout();

    await serviceLocator<AuthLocalService>().clearTokens();

    return result;
  }

  @override
  Future<Either> refresh() async {
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
  Future<Either<String, UserEntity>> loginWithGoogle() async {
    try {
      print('Starting Google Sign-In process');
      final GoogleSignInAccount? googleUser = await serviceLocator<AuthApiService>().signInWithGoogle();

      if (googleUser == null) {
        print('Google Sign-In aborted by user');
        return Left('Sign-in aborted by user');
      }

      print('Google Sign-In successful, user: ${googleUser.email}');
      print('Initiating server-side authentication');
      final response = await serviceLocator<AuthApiService>().googleLoginFromApp(googleUser);

      return response.fold(
        (error) {
          print('Server-side authentication failed: $error');
          return Left(error);
        },
        (data) {
          print('Server-side authentication successful');
          return _handleAuthResponse(data);
        },
      );
    } catch (e) {
      print('Google Sign-In failed with exception: ${e.toString()}');
      return Left('Google Sign-In failed: ${e.toString()}');
    }
  }
}
