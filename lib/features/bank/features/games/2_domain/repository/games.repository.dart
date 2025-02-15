import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';

abstract class GamesRepository {
  Future<Either<String, GameEntity>> getGameFromBarcode(String? request);
}
