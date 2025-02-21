import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:le_spawn_fr/features/auth/1_data/source/auth-local.service.dart';
import 'package:le_spawn_fr/core/constant/api-url.constant.dart';
import 'package:le_spawn_fr/core/network/dio_client.dart';
import 'package:le_spawn_fr/core/di/service-locator.dart';

abstract class ReportsApiService {
  Future<Either<String, dynamic>> createGameReport(String gameId, Map<String, dynamic> reportData);
  Future<Either<String, List<dynamic>>> getGameReports(String gameId);
  Future<Either<String, List<dynamic>>> getMyReports();
  Future<Either<String, dynamic>> updateReportStatus(String reportId, String status);
}

class ReportsApiServiceImpl implements ReportsApiService {
  @override
  Future<Either<String, dynamic>> createGameReport(String gameId, Map<String, dynamic> reportData) async {
    try {
      final accessToken = await serviceLocator<AuthLocalService>().getAccessToken();
      final response = await serviceLocator<DioClient>().post(
        ApiUrlConstant.createGameReport,
        data: {
          'gameId': gameId,
          ...reportData,
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
  Future<Either<String, List<dynamic>>> getGameReports(String gameId) async {
    try {
      final accessToken = await serviceLocator<AuthLocalService>().getAccessToken();
      final response = await serviceLocator<DioClient>().get(
        '${ApiUrlConstant.getGameReports}/$gameId',
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
  Future<Either<String, List<dynamic>>> getMyReports() async {
    try {
      final accessToken = await serviceLocator<AuthLocalService>().getAccessToken();
      final response = await serviceLocator<DioClient>().get(
        ApiUrlConstant.getMyReports,
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
  Future<Either<String, dynamic>> updateReportStatus(String reportId, String status) async {
    try {
      final accessToken = await serviceLocator<AuthLocalService>().getAccessToken();
      final response = await serviceLocator<DioClient>().put(
        '${ApiUrlConstant.updateReportStatus}/$reportId/status',
        data: {
          'status': status,
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
