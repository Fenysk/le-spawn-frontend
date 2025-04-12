import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:le_spawn_fr/core/constant/api-url.constant.dart';
import 'package:le_spawn_fr/core/di/service-locator.dart';
import 'package:le_spawn_fr/core/network/dio_client.dart';
import 'package:le_spawn_fr/features/auth/1_data/source/auth-local.service.dart';
import 'package:le_spawn_fr/features/collections/features/new-game-item/1_data/dto/submit-game-photos.request.dart';

abstract class NewGameItemApiService {
  Future<Either<String, void>> submitGamePhotos(SubmitGamePhotosRequest dto);
}

class NewGameItemApiServiceImpl implements NewGameItemApiService {
  @override
  Future<Either<String, void>> submitGamePhotos(SubmitGamePhotosRequest dto) async {
    try {
      final accessToken = await serviceLocator<AuthLocalService>().getAccessToken();
      await serviceLocator<DioClient>().post(
        ApiUrlConstant.newGameItem,
        data: dto.toJson(),
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken'
        }),
      );
      return const Right(null);
    } on DioException catch (error) {
      return Left(error.response?.data['message'] ?? error.message ?? 'An error occurred');
    }
  }
}
