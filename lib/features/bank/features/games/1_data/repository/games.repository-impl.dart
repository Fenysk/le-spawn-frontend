import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/features/bank/features/games/1_data/dto/search-games.request.dart';
import 'package:le_spawn_fr/features/bank/features/games/1_data/model/game.model.dart';
import 'package:le_spawn_fr/features/bank/features/games/1_data/source/games-api.service.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/repository/games.repository.dart';
import 'package:le_spawn_fr/core/di/service-locator.dart';
import '../dto/get-games-from-images-request.dto.dart';

class GamesRepositoryImpl implements GamesRepository {
  @override
  Future<Either<String, List<GameEntity>>> searchGamesInBank(SearchGamesRequest? request) async {
    Either<String, dynamic> response = await serviceLocator<GamesApiService>().searchGamesInBank(request);

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

  @override
  Future<Either<String, List<GameEntity>>> searchGamesInProviders(SearchGamesRequest? request) async {
    Either<String, dynamic> response = await serviceLocator<GamesApiService>().searchGamesInProviders(request);

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

  @override
  Future<Either<String, List<GameEntity>>> searchGamesFromBarcode(SearchGamesRequest? request) async {
    if (request == null || request.barcode == null) return Left('Barcode is missing');

    Either<String, dynamic> response = await serviceLocator<GamesApiService>().searchGamesFromBarcode(request.barcode!);

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

  @override
  Future<Either<String, List<GameEntity>>> fetchGamesFromImages(GetGamesFromImagesRequest request) async {
    Either<String, dynamic> response = await serviceLocator<GamesApiService>().fetchGamesFromImages(request);

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
