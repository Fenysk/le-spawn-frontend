import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/features/bank/features/games/1_data/dto/search-games.request.dart';
import 'package:le_spawn_fr/features/bank/features/games/1_data/model/game.model.dart';
import 'package:le_spawn_fr/features/bank/features/games/1_data/source/games-api.service.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/repository/games.repository.dart';
import 'package:le_spawn_fr/service-locator.dart';

class GamesRepositoryImpl implements GamesRepository {
  @override
  Future<Either<String, List<GameEntity>>> getGames(SearchGamesRequest? request) async {
    Either<String, dynamic> response = await serviceLocator<GamesApiService>().getGames(request);

    return response.fold(
      (error) => Left(error),
      (data) {
        if (data is List) {
          List<GameModel> games = data.map((e) => GameModel.fromMap(e as Map<String, dynamic>)).toList();
          List<GameEntity> gameEntities = games.map((e) => e.toEntity()).toList();
          return Right(gameEntities);
        }
        return Left('Unexpected response format from API');
      },
    );
  }
}
