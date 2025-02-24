import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:le_spawn_fr/core/constant/api-url.constant.dart';
import 'package:le_spawn_fr/core/network/dio_client.dart';
import 'package:le_spawn_fr/core/di/service-locator.dart';

abstract class UpdateCheckerApiService {
  Future<Either<String, void>> checkForUpdate(String currentVersion);
}

class UpdateCheckerSourceImpl implements UpdateCheckerApiService {
  @override
  Future<Either<String, void>> checkForUpdate(String currentVersion) async {
    try {
      await serviceLocator<DioClient>().get(
        '${ApiUrlConstant.baseUrl}/check-update/$currentVersion',
      );

      return Right(null);
    } on DioException catch (error) {
      return Left(error.response?.data['message'] ?? error.message ?? 'An error occurred');
    }
  }
}
