import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:le_spawn_frontend/features/auth/1_data/source/auth-local.service.dart';
import 'package:le_spawn_frontend/core/constant/api-url.constant.dart';
import 'package:le_spawn_frontend/core/network/dio_client.dart';
import 'package:le_spawn_frontend/features/bank/features/games/1_data/model/game.model.dart';
import 'package:le_spawn_frontend/features/bank/features/games/2_domain/entity/game.entity.dart';
import 'package:le_spawn_frontend/service-locator.dart';

abstract class GamesApiService {
  Future<Either<String, GameEntity>> getGameFromBarcode(String? request);
}

class GamesApiServiceImpl implements GamesApiService {
  @override
  Future<Either<String, GameEntity>> getGameFromBarcode(String? request) async {
    try {
      final accessToken = await serviceLocator<AuthLocalService>().getAccessToken();
      final response = await serviceLocator<DioClient>().get(
        '${ApiUrlConstant.getGameFromBarcode}/$request',
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken'
        }),
      );

      final game = GameModel.fromMap(response.data).toEntity();

      return Right(game);
    } on DioException catch (error) {
      return Left(error.response?.data['message'] ?? error.message ?? 'An error occurred');
    }
  }
}
