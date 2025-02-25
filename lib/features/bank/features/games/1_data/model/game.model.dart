import 'dart:convert';
import 'package:le_spawn_fr/core/enums/game-category.enum.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';
import 'package:le_spawn_fr/features/bank/features/platforms/1_data/model/platform.model.dart';
import 'package:le_spawn_fr/features/collections/1_data/model/game-item.model.dart';

class GameModel {
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
  final List<PlatformModel> platforms;
  final List<GameItemModel> gameCollectionItem;

  GameModel({
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
    required this.gameCollectionItem,
  });

  static GameModel get empty => GameModel(
        id: '',
        igdbGameId: null,
        barcodes: [],
        category: GameCategoryEnum.mainGame,
        coverUrl: null,
        firstReleaseDate: DateTime.now(),
        franchises: [],
        genres: [],
        name: '',
        screenshotsUrl: [],
        storyline: null,
        summary: null,
        platforms: [],
        gameCollectionItem: [],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'igdbGameId': igdbGameId,
      'barcodes': barcodes,
      'category': category.toString().split('.').last,
      'coverUrl': coverUrl,
      'firstReleaseDate': firstReleaseDate.toIso8601String(),
      'franchises': franchises,
      'genres': genres,
      'name': name,
      'screenshotsUrl': screenshotsUrl,
      'storyline': storyline,
      'summary': summary,
      'platforms': platforms.map((platform) => platform.toMap()).toList(),
      'gameCollectionItem': gameCollectionItem.map((item) => item.toMap()).toList(),
    };
  }

  factory GameModel.fromMap(Map<String, dynamic> map) {
    return GameModel(
      id: map['id'],
      igdbGameId: map['igdbGameId'],
      barcodes: List<String>.from(map['barcodes']),
      category: GameCategoryEnum.values.firstWhere((e) => e.toString().split('.').last == map['category']),
      coverUrl: map['coverUrl'],
      firstReleaseDate: DateTime.parse(map['firstReleaseDate']),
      franchises: List<String>.from(map['franchises']),
      genres: List<String>.from(map['genres']),
      name: map['name'],
      screenshotsUrl: List<String>.from(map['screenshotsUrl']),
      storyline: map['storyline'],
      summary: map['summary'],
      platforms: List<PlatformModel>.from(map['platforms']?.map((x) => PlatformModel.fromMap(x)) ?? []),
      gameCollectionItem: List<GameItemModel>.from(map['gameCollectionItem']?.map((x) => GameItemModel.fromMap(x)) ?? []),
    );
  }

  String toJson() => json.encode(toMap());

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
      );
}
