import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:le_spawn_frontend/core/constant/api-url.constant.dart';
import 'package:le_spawn_frontend/core/network/dio_client.dart';
import 'package:le_spawn_frontend/features/auth/1_data/dto/login.request.dart';
import 'package:le_spawn_frontend/features/auth/1_data/dto/register.request.dart';
import 'package:le_spawn_frontend/features/auth/1_data/source/auth-local.service.dart';
import 'package:le_spawn_frontend/service-locator.dart';

abstract class AuthApiService {
  Future<Either> register(RegisterRequest registerRequest);

  Future<Either> getMyProfile();

  Future<Either> login(LoginRequest loginRequest);

  Future<Either> logout();

  Future<Either> refresh(String refreshToken);
}

class AuthApiServiceImpl extends AuthApiService {
  @override
  Future<Either> register(RegisterRequest registerRequest) async {
    try {
      final response = await serviceLocator<DioClient>().post(
        ApiUrlConstant.register,
        data: registerRequest.toMap(),
      );

      return Right(response);
    } on DioException catch (error) {
      return Left(error.response!.data['message']);
    }
  }

  @override
  Future<Either> getMyProfile() async {
    try {
      final accessToken =
          await serviceLocator<AuthLocalService>().getAccessToken();

      final response = await serviceLocator<DioClient>().get(
        ApiUrlConstant.getMyProfile,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      return Right(response);
    } on DioException catch (error) {
      return Left(error.response!.data['message']);
    }
  }

  @override
  Future<Either> login(LoginRequest loginRequest) async {
    try {
      final response = await serviceLocator<DioClient>().post(
        ApiUrlConstant.login,
        data: loginRequest.toMap(),
      );

      return Right(response);
    } on DioException catch (error) {
      return Left(error.response!.data['message']);
    }
  }

  @override
  Future<Either> logout() async {
    try {
      final accessToken =
          await serviceLocator<AuthLocalService>().getAccessToken();

      final response = await serviceLocator<DioClient>().post(
        ApiUrlConstant.logout,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      return Right(response);
    } on DioException catch (error) {
      return Left(error.response!.data['message']);
    }
  }

  @override
  Future<Either> refresh(String refreshToken) async {
    try {
      final response = await serviceLocator<DioClient>().post(
        ApiUrlConstant.refresh,
        options: Options(
          headers: {
            'Authorization': 'Bearer $refreshToken',
          },
        ),
      );

      return Right(response);
    } on DioException catch (error) {
      return Left(error.response!.data['message']);
    }
  }
}
