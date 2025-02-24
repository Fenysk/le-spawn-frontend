import 'dart:convert';
import 'package:le_spawn_fr/core/enums/game-category.enum.dart';
import 'package:le_spawn_fr/features/bank/features/games/1_data/model/game-localization.model.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';
import 'package:le_spawn_fr/features/bank/features/platforms/1_data/model/platform.model.dart';
import 'package:le_spawn_fr/features/collections/1_data/model/game-item.model.dart';

class GameModel {
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
  final List<PlatformModel> platforms;
  final List<GameItemModel> gameCollectionItem;
  final List<GameLocalizationModel> gameLocalizations;

  GameModel({
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
    required this.gameCollectionItem,
    required this.gameLocalizations,
  });

  static GameModel get empty => GameModel(
        id: '',
        igdbGameId: null,
        barcodes: [],
        category: GameCategoryEnum.mainGame,
        coverUrl: null,
        firstReleaseDate: null,
        franchises: [],
        genres: [],
        name: '',
        screenshotsUrl: [],
        storyline: null,
        summary: null,
        platforms: [],
        gameCollectionItem: [],
        gameLocalizations: [],
      );

  String toJson() {
    return json.encode({
      'id': id,
      'igdbGameId': igdbGameId,
      'barcodes': barcodes,
      'category': category.toString().split('.').last,
      'coverUrl': coverUrl,
      'firstReleaseDate': firstReleaseDate?.toIso8601String(),
      'franchises': franchises,
      'genres': genres,
      'name': name,
      'screenshotsUrl': screenshotsUrl,
      'storyline': storyline,
      'summary': summary,
      'platforms': platforms.map((platform) => platform.toJson()).toList(),
      'gameCollectionItem': gameCollectionItem.map((item) => item.toJson()).toList(),
      'gameLocalizations': gameLocalizations.map((localization) => localization.toJson()).toList(),
    });
  }

  factory GameModel.fromMap(Map<String, dynamic> map) {
    return GameModel(
      id: map['id'],
      igdbGameId: map['igdbGameId'],
      barcodes: List<String>.from(map['barcodes'] ?? []),
      category: GameCategoryEnum.values.firstWhere((e) => e.toString().split('.').last == map['category']),
      coverUrl: map['coverUrl'],
      firstReleaseDate: map['firstReleaseDate'] != null ? DateTime.parse(map['firstReleaseDate']) : null,
      franchises: List<String>.from(map['franchises'] ?? []),
      genres: List<String>.from(map['genres'] ?? []),
      name: map['name'],
      screenshotsUrl: List<String>.from(map['screenshotsUrl'] ?? []),
      storyline: map['storyline'],
      summary: map['summary'],
      platforms: (map['platformsRelation'] as List<dynamic>?)?.map((relation) => PlatformModel.fromMap(relation['platform'] as Map<String, dynamic>)).toList() ?? [],
      gameCollectionItem: List<GameItemModel>.from(map['gameCollectionItem']?.map((x) => GameItemModel.fromMap(x)) ?? []),
      gameLocalizations: List<GameLocalizationModel>.from(map['gameLocalizations']?.map((x) => GameLocalizationModel.fromMap(x as Map<String, dynamic>)) ?? []),
    );
  }

  factory GameModel.fromJson(String source) => GameModel.fromMap(json.decode(source));
}

extension GameModelExtension on GameModel {
  GameEntity toEntity() => GameEntity(
        id: id,
        igdbGameId: igdbGameId,
        barcodes: barcodes,
        category: category,
        coverUrl: coverUrl,
        firstReleaseDate: firstReleaseDate,
        franchises: franchises,
        genres: genres,
        name: name,
        screenshotsUrl: screenshotsUrl,
        storyline: storyline,
        summary: summary,
        platforms: platforms.map((platform) => platform.toEntity()).toList(),
        gameItems: gameCollectionItem.map((item) => item.toEntity()).toList(),
        gameLocalizations: gameLocalizations.map((localization) => localization.toEntity()).toList(),
      );
}
