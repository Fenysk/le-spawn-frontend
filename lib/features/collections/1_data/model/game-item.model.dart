import 'dart:convert';
import 'package:le_spawn_frontend/features/bank/features/games/1_data/model/game.model.dart';
import 'package:le_spawn_frontend/features/collections/2_domain/entity/game-item.entity.dart';

class GameCollectionItemModel {
  final String id;
  final bool hasBox;
  final bool hasGame;
  final bool hasPaper;
  final String? stateBox;
  final String? stateGame;
  final String? statePaper;
  final String gameId;
  final String collectionId;
  final GameModel game;

  GameCollectionItemModel({
    required this.id,
    required this.hasBox,
    required this.hasGame,
    required this.hasPaper,
    this.stateBox,
    this.stateGame,
    this.statePaper,
    required this.gameId,
    required this.collectionId,
    required this.game,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'hasBox': hasBox,
      'hasGame': hasGame,
      'hasPaper': hasPaper,
      'stateBox': stateBox,
      'stateGame': stateGame,
      'statePaper': statePaper,
      'gameId': gameId,
      'collectionId': collectionId,
      'game': game.toMap(),
    };
  }

  factory GameCollectionItemModel.fromMap(Map<String, dynamic> map) {
    return GameCollectionItemModel(
      id: map['id'] ?? '',
      hasBox: map['hasBox'] ?? false,
      hasGame: map['hasGame'] ?? false,
      hasPaper: map['hasPaper'] ?? false,
      stateBox: map['stateBox'],
      stateGame: map['stateGame'],
      statePaper: map['statePaper'],
      gameId: map['gameId'] ?? '',
      collectionId: map['collectionId'] ?? '',
      game: GameModel.fromMap(map['game'] ?? {}),
    );
  }

  String toJson() => json.encode(toMap());

  factory GameCollectionItemModel.fromJson(String source) => GameCollectionItemModel.fromMap(json.decode(source));
}

extension GameCollectionItemModelExtension on GameCollectionItemModel {
  GameCollectionItemEntity toEntity() => GameCollectionItemEntity(
        id: id,
        hasBox: hasBox,
        hasGame: hasGame,
        hasPaper: hasPaper,
        stateBox: stateBox,
        stateGame: stateGame,
        statePaper: statePaper,
        gameId: gameId,
        collectionId: collectionId,
        game: game.toEntity(),
      );
}
