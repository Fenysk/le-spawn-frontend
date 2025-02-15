import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/features/bank/features/games/1_data/source/games-api.service.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/repository/games.repository.dart';
import 'package:le_spawn_fr/service-locator.dart';

class GamesRepositoryImpl implements GamesRepository {
  @override
  Future<Either<String, GameEntity>> getGameFromBarcode(String? request) async {
    Either<String, GameEntity> response = await serviceLocator<GamesApiService>().getGameFromBarcode(request);

    return response.fold(
      (error) => Left(error),
      (data) => Right(data),
    );
  }
}
