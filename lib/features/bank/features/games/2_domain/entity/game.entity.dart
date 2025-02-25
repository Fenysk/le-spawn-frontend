import 'package:le_spawn_fr/core/enums/game-category.enum.dart';
import 'package:le_spawn_fr/features/bank/features/platforms/2_domain/entity/platform.entity.dart';
import 'package:le_spawn_fr/features/collections/2_domain/entity/game-item.entity.dart';

class GameEntity {
  final String id;
  final int? igdbGameId;
  final List<String> barcodes;
  final GameCategoryEnum category;
  final String? coverUrl;
  final DateTime firstReleaseDate;
  final List<String> franchises;
  final List<String> genres;
  final String name;
  final List<String> screenshotsUrl;
  final String? storyline;
  final String? summary;
  final List<PlatformEntity> platforms;
  final List<GameItemEntity> gameItems;

  GameEntity({
    required this.id,
    this.igdbGameId,
    required this.barcodes,
    required this.category,
    this.coverUrl,
    required this.firstReleaseDate,
    required this.franchises,
    required this.genres,
    required this.name,
    required this.screenshotsUrl,
    this.storyline,
    this.summary,
    required this.platforms,
    required this.gameItems,
  });
}
