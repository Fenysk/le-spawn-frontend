import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:le_spawn_fr/core/constant/api-url.constant.dart';
import 'package:le_spawn_fr/core/network/dio_client.dart';
import 'package:le_spawn_fr/features/auth/1_data/dto/login.request.dart';
import 'package:le_spawn_fr/features/auth/1_data/dto/register.request.dart';
import 'package:le_spawn_fr/features/auth/1_data/source/auth-local.service.dart';
import 'package:le_spawn_fr/service-locator.dart';

abstract class AuthApiService {
  Future<Either> register(RegisterRequest registerRequest);

  Future<Either> getMyProfile();

  Future<Either<String, dynamic>> login(LoginRequest loginRequest);

  Future<Either> logout();

  Future<Either> refresh(String refreshToken);

  Future<GoogleSignInAccount?> signInWithGoogle();

  Future<Either<String, dynamic>> googleLoginFromApp(GoogleSignInAccount googleProfile);
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
      final accessToken = await serviceLocator<AuthLocalService>().getAccessToken();

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
  Future<Either<String, dynamic>> login(LoginRequest loginRequest) async {
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
    final accessToken = await serviceLocator<AuthLocalService>().getAccessToken();

    try {
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

  @override
  Future<GoogleSignInAccount?> signInWithGoogle() async {
    return await GoogleSignIn().signIn();
  }

  @override
  Future<Either<String, dynamic>> googleLoginFromApp(GoogleSignInAccount googleProfile) async {
    try {
      print('Attempting Google login from app for user: ${googleProfile.email}');
      final Map<String, dynamic> body = {
        'id': googleProfile.id,
        'email': googleProfile.email,
        'displayName': googleProfile.displayName,
        'photoUrl': googleProfile.photoUrl,
      };
      print(body);
      final response = await serviceLocator<DioClient>().post(
        ApiUrlConstant.googleLoginFromApp,
        data: jsonEncode(body),
        options: Options(headers: {
          'Content-Type': 'application/json'
        }),
      );
      print('Google login response: ${response.data}');
      return Right(response);
    } on DioException catch (error) {
      print('Google login failed: ${error.message}');
      return Left(error.response?.data['message'] ?? 'An error occurred during Google login');
    }
  }
}
