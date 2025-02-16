import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:le_spawn_fr/features/auth/1_data/source/auth-local.service.dart';
import 'package:le_spawn_fr/core/constant/api-url.constant.dart';
import 'package:le_spawn_fr/core/network/dio_client.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/1_data/dto/add-new-game-to-collection.request.dart';
import 'package:le_spawn_fr/service-locator.dart';

abstract class NewItemApiService {
  Future<Either<String, dynamic>> addGameToCollection(AddGameItemToCollectionRequest dto);
}

class NewItemApiServiceImpl implements NewItemApiService {
  @override
  Future<Either<String, dynamic>> addGameToCollection(AddGameItemToCollectionRequest dto) async {
    try {
      final accessToken = await serviceLocator<AuthLocalService>().getAccessToken();
      final response = await serviceLocator<DioClient>().post(
        ApiUrlConstant.addGameToCollection,
        data: dto.toJson(),
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
