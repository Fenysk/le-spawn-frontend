import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/core/usecase/usecase.dart';
import 'package:le_spawn_fr/features/bank/features/games/1_data/dto/search-games.request.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/repository/games.repository.dart';
import 'package:le_spawn_fr/service-locator.dart';

class SearchGamesInProvidersUsecase implements Usecase<Either<String, List<GameEntity>>, SearchGamesRequest?> {
  @override
  Future<Either<String, List<GameEntity>>> execute({
    SearchGamesRequest? request,
  }) async {
    return serviceLocator<GamesRepository>().searchGamesInProviders(request);
  }
}
