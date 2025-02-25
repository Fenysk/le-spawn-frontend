import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:le_spawn_fr/features/auth/1_data/dto/login.request.dart';
import 'package:le_spawn_fr/features/auth/1_data/dto/register.request.dart';
import 'package:le_spawn_fr/features/auth/1_data/source/auth-api.service.dart';
import 'package:le_spawn_fr/features/auth/1_data/source/auth-local.service.dart';
import 'package:le_spawn_fr/features/auth/2_domain/repository/auth.repository.dart';
import 'package:le_spawn_fr/features/user/1_data/model/user.model.dart';
import 'package:le_spawn_fr/features/user/1_data/source/user-local.service.dart';
import 'package:le_spawn_fr/service-locator.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either> register(RegisterRequest registerRequest) async {
    Either result = await serviceLocator<AuthApiService>().register(registerRequest);

    return result.fold(
      (error) => Left(error),
      (data) async {
        Response response = data;

        final accessToken = response.data['tokens']['accessToken'];
        final user = response.data['user'];

        if (accessToken != null) await serviceLocator<AuthLocalService>().setAccessToken(accessToken);

        final userModel = UserModel.fromMap(user);
        if (user != null) await serviceLocator<UserLocalService>().setCurrentUser(userModel);

        return Right(user);
      },
    );
  }

  @override
  Future<bool> isLoggedIn() async {
    return await serviceLocator<AuthLocalService>().isLoggedIn();
  }

  @override
  Future<Either> login(LoginRequest loginRequest) async {
    Either result = await serviceLocator<AuthApiService>().login(loginRequest);

    return result.fold(
      (error) => Left(error),
      (data) async {
        Response response = data;

        final accessToken = response.data['tokens']['accessToken'];
        final refreshToken = response.data['tokens']['refreshToken'];
        final user = response.data['user'];

        if (accessToken != null) await serviceLocator<AuthLocalService>().setAccessToken(accessToken);
        if (refreshToken != null) await serviceLocator<AuthLocalService>().setRefreshToken(refreshToken);

        final userModel = UserModel.fromMap(user);
        if (user != null) await serviceLocator<UserLocalService>().setCurrentUser(userModel);

        return Right(user);
      },
    );
  }

  @override
  Future<Either> logout() async {
    Either result = await serviceLocator<AuthApiService>().logout();

    await serviceLocator<AuthLocalService>().clearTokens();

    return result.fold(
      (error) async => Left(error),
      (data) async => Right(data),
    );
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
      (data) async {
        Response response = data;

        final accessToken = response.data['tokens']['accessToken'];
        final refreshToken = response.data['tokens']['refreshToken'];
        final user = response.data['user'];

        if (accessToken != null) await serviceLocator<AuthLocalService>().setAccessToken(accessToken);
        if (refreshToken != null) await serviceLocator<AuthLocalService>().setRefreshToken(refreshToken);

        final userModel = UserModel.fromMap(user);
        if (user != null) await serviceLocator<UserLocalService>().setCurrentUser(userModel);

        return Right(accessToken);
      },
    );
  }
}
