import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:le_spawn_fr/features/auth/1_data/source/auth-local.service.dart';
import 'package:le_spawn_fr/core/constant/api-url.constant.dart';
import 'package:le_spawn_fr/core/network/dio_client.dart';
import 'package:le_spawn_fr/features/bank/features/games/1_data/dto/search-games.request.dart';
import 'package:le_spawn_fr/core/di/service-locator.dart';

abstract class GamesApiService {
  Future<Either<String, dynamic>> searchGamesInBank(SearchGamesRequest? searchGameRequest);
  Future<Either<String, dynamic>> searchGamesInProviders(SearchGamesRequest? searchGameRequest);
  Future<Either<String, dynamic>> searchGamesFromBarcode(String barcode);
}

class GamesApiServiceImpl implements GamesApiService {
  @override
  Future<Either<String, dynamic>> searchGamesInBank(SearchGamesRequest? searchGameRequest) async {
    try {
      final accessToken = await serviceLocator<AuthLocalService>().getAccessToken();
      final response = await serviceLocator<DioClient>().get(
        ApiUrlConstant.searchGamesInBank,
        data: searchGameRequest?.toJson(),
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
  Future<Either<String, dynamic>> searchGamesInProviders(SearchGamesRequest? searchGameRequest) async {
    try {
      final accessToken = await serviceLocator<AuthLocalService>().getAccessToken();
      final response = await serviceLocator<DioClient>().get(
        ApiUrlConstant.searchGamesInProviders,
        data: searchGameRequest?.toJson(),
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
  Future<Either<String, dynamic>> searchGamesFromBarcode(String barcode) async {
    try {
      final accessToken = await serviceLocator<AuthLocalService>().getAccessToken();
      final response = await serviceLocator<DioClient>().get(
        '${ApiUrlConstant.searchGamesFromBarcode}/$barcode',
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
