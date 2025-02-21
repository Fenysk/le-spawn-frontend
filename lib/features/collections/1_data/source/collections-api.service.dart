import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:le_spawn_fr/features/auth/1_data/source/auth-local.service.dart';
import 'package:le_spawn_fr/core/constant/api-url.constant.dart';
import 'package:le_spawn_fr/core/network/dio_client.dart';
import 'package:le_spawn_fr/core/di/service-locator.dart';

abstract class CollectionsApiService {
  Future<Either<String, List<dynamic>>> getMyCollections();
  Future<Either<String, dynamic>> getCollectionById(String collectionId);
  Future<Either<String, dynamic>> createCollection(String title);
  Future<Either<String, dynamic>> updateCollection(String collectionId, String title);
  Future<Either<String, String>> deleteCollection(String collectionId);
  Future<Either<String, String>> deleteGameItem(String gameItemId);
}

class CollectionsApiServiceImpl implements CollectionsApiService {
  @override
  Future<Either<String, List<dynamic>>> getMyCollections() async {
    try {
      final accessToken = await serviceLocator<AuthLocalService>().getAccessToken();
      final response = await serviceLocator<DioClient>().get(
        ApiUrlConstant.getMyCollections,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken'
        }),
      );
      return Right(response.data as List<dynamic>);
    } on DioException catch (error) {
      return Left(error.response?.data['message'] ?? error.message ?? 'An error occurred');
    }
  }

  @override
  Future<Either<String, dynamic>> getCollectionById(String collectionId) async {
    try {
      final accessToken = await serviceLocator<AuthLocalService>().getAccessToken();
      final response = await serviceLocator<DioClient>().get(
        '${ApiUrlConstant.getCollectionById}/$collectionId',
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken'
        }),
      );
      return Right(response.data);
    } on DioException catch (error) {
      return Left(error.response?.data['message'] ?? error.message ?? 'An error occurred');
    }
  }

  @override
  Future<Either<String, dynamic>> createCollection(String title) async {
    try {
      final accessToken = await serviceLocator<AuthLocalService>().getAccessToken();
      final response = await serviceLocator<DioClient>().post(
        ApiUrlConstant.createCollection,
        data: {
          'title': title
        },
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken'
        }),
      );
      return Right(response.data);
    } on DioException catch (error) {
      return Left(error.response?.data['message'] ?? error.message ?? 'An error occurred');
    }
  }

  @override
  Future<Either<String, dynamic>> updateCollection(String collectionId, String title) async {
    try {
      final accessToken = await serviceLocator<AuthLocalService>().getAccessToken();
      final response = await serviceLocator<DioClient>().put(
        '${ApiUrlConstant.updateCollection}/$collectionId',
        data: {
          'title': title
        },
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken'
        }),
      );
      return Right(response.data);
    } on DioException catch (error) {
      return Left(error.response?.data['message'] ?? error.message ?? 'An error occurred');
    }
  }

  @override
  Future<Either<String, String>> deleteCollection(String collectionId) async {
    try {
      final accessToken = await serviceLocator<AuthLocalService>().getAccessToken();
      await serviceLocator<DioClient>().delete(
        '${ApiUrlConstant.deleteCollection}/$collectionId',
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken'
        }),
      );
      return Right('Collection deleted successfully');
    } on DioException catch (error) {
      return Left(error.response?.data['message'] ?? error.message ?? 'An error occurred');
    }
  }

  @override
  Future<Either<String, String>> deleteGameItem(String gameItemId) async {
    try {
      final accessToken = await serviceLocator<AuthLocalService>().getAccessToken();
      await serviceLocator<DioClient>().delete(
        '${ApiUrlConstant.deleteGameItem}/$gameItemId',
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken'
        }),
      );
      return Right('Game item deleted successfully');
    } on DioException catch (error) {
      return Left(error.response?.data['message'] ?? error.message ?? 'An error occurred');
    }
  }
}
