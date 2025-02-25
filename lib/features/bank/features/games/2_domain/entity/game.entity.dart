import 'dart:convert';
import 'package:le_spawn_fr/core/enums/game-category.enum.dart';
import 'package:le_spawn_fr/features/bank/features/platforms/2_domain/entity/platform.entity.dart';
import 'package:le_spawn_fr/features/collections/2_domain/entity/game-item.entity.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game-localization.entity.dart';

class GameEntity {
  final String id;
  final int? igdbGameId;
  final List<String> barcodes;
  final GameCategoryEnum category;
  final String? coverUrl;
  final DateTime? firstReleaseDate;
  final List<String> franchises;
  final List<String> genres;
  final String name;
  final List<String> screenshotsUrl;
  final String? storyline;
  final String? summary;
  final List<PlatformEntity> platforms;
  final List<GameItemEntity> gameItems;
  final List<GameLocalizationEntity> gameLocalizations;

  GameEntity({
    required this.id,
    this.igdbGameId,
    required this.barcodes,
    required this.category,
    this.coverUrl,
    this.firstReleaseDate,
    required this.franchises,
    required this.genres,
    required this.name,
    required this.screenshotsUrl,
    this.storyline,
    this.summary,
    required this.platforms,
    required this.gameItems,
    required this.gameLocalizations,
  });

  String toJson() {
    return jsonEncode({
      'id': id,
      'igdbGameId': igdbGameId,
      'barcodes': barcodes,
      'category': category.toString(),
      'coverUrl': coverUrl,
      'firstReleaseDate': firstReleaseDate?.toIso8601String(),
      'franchises': franchises,
      'genres': genres,
      'name': name,
      'screenshotsUrl': screenshotsUrl,
      'storyline': storyline,
      'summary': summary,
      'platforms': platforms.map((platform) => platform.toJson()).toList(),
      'gameItems': gameItems.map((gameItem) => gameItem.toJson()).toList(),
      'gameLocalizations': gameLocalizations.map((localization) => localization.toJson()).toList(),
    });
  }
}
