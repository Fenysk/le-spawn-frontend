import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/core/usecase/usecase.dart';
import 'package:le_spawn_fr/features/bank/features/games/1_data/dto/get-games-from-images-request.dto.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/repository/games.repository.dart';
import 'package:le_spawn_fr/core/di/service-locator.dart';

class FetchGamesFromImagesUsecase implements Usecase<Either<String, List<GameEntity>>, GetGamesFromImagesRequest> {
  @override
  Future<Either<String, List<GameEntity>>> execute({
    GetGamesFromImagesRequest? request,
  }) async {
    if (request == null) return Left('Request cannot be null');
    return serviceLocator<GamesRepository>().fetchGamesFromImages(request);
  }
}
