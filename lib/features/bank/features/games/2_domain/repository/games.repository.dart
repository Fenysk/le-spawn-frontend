import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/features/bank/features/games/1_data/dto/search-games.request.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';
import 'package:le_spawn_fr/features/bank/features/games/1_data/dto/get-games-from-images-request.dto.dart';

abstract class GamesRepository {
  Future<Either<String, List<GameEntity>>> searchGamesInBank(SearchGamesRequest? request);
  Future<Either<String, List<GameEntity>>> searchGamesInProviders(SearchGamesRequest? request);
  Future<Either<String, List<GameEntity>>> searchGamesFromBarcode(SearchGamesRequest? request);
  Future<Either<String, List<GameEntity>>> fetchGamesFromImages(GetGamesFromImagesRequest request);
}
