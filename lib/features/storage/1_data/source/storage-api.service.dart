import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:le_spawn_fr/core/constant/api-url.constant.dart';
import 'package:le_spawn_fr/core/di/service-locator.dart';
import 'package:le_spawn_fr/core/network/dio_client.dart';
import 'package:le_spawn_fr/features/auth/1_data/source/auth-local.service.dart';

abstract class StorageApiService {
  Future<Either<String, dynamic>> uploadFile(
    File file, {
    String? bucket,
  });

  Future<Either<String, dynamic>> deleteFileFromUrl(
    String url, {
    String? bucket,
  });
}

class StorageApiServiceImpl implements StorageApiService {
  @override
  Future<Either<String, dynamic>> uploadFile(
    File file, {
    String? bucket,
  }) async {
    try {
      final accessToken = await serviceLocator<AuthLocalService>().getAccessToken();
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path),
        if (bucket != null) 'bucket': bucket,
      });

      final response = await serviceLocator<DioClient>().post(
        ApiUrlConstant.uploadFile,
        data: formData,
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
  Future<Either<String, dynamic>> deleteFileFromUrl(
    String url, {
    String? bucket,
  }) async {
    try {
      final accessToken = await serviceLocator<AuthLocalService>().getAccessToken();
      final response = await serviceLocator<DioClient>().delete(
        ApiUrlConstant.deleteFile,
        data: {
          'url': url,
          if (bucket != null) 'bucket': bucket,
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
}
