import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:le_spawn_frontend/features/auth/1_data/source/auth-local.service.dart';
import 'package:le_spawn_frontend/core/constants/api-urls.dart';
import 'package:le_spawn_frontend/core/network/dio_client.dart';
import 'package:le_spawn_frontend/service-locator.dart';

abstract class UsersApiService {
  Future<Either> getMyProfile();

  Future<Either> getUserProfile(String userId);

  Future<Either> checkIfPseudoExist(String pseudo);
}

class UsersApiServiceImpl extends UsersApiService {
  @override
  Future<Either> getMyProfile() async {
    try {
      final accessToken = await serviceLocator<AuthLocalService>().getAccessToken();

      final response = await serviceLocator<DioClient>().get(
        ApiUrls.getMyProfile,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      return Right(response);
    } on DioException catch (error) {
      if (error.response != null) return Left(error.response!.data['message']);
      return Left(error.message);
    }
  }

  @override
  Future<Either> getUserProfile(String userId) async {
    try {
      final accessToken = await serviceLocator<AuthLocalService>().getAccessToken();

      final response = await serviceLocator<DioClient>().get(
        '${ApiUrls.getUserProfile}/$userId',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      return Right(response);
    } on DioException catch (error) {
      if (error.response != null) return Left(error.response!.data['message']);
      return Left(error.message);
    }
  }

  @override
  Future<Either> checkIfPseudoExist(String pseudo) async {
    try {
      final response = await serviceLocator<DioClient>().get(
        ApiUrls.checkIfPseudoExist,
        queryParameters: {
          'pseudo': pseudo,
        },
      );

      return Right(response);
    } on DioException catch (error) {
      return Left(error.response!.data['message']);
    }
  }
}
