import 'dart:convert';
import 'package:le_spawn_fr/features/bank/features/games/1_data/model/game.model.dart';
import 'package:le_spawn_fr/features/collections/2_domain/entity/game-item.entity.dart';

class GameItemModel {
  final String id;
  final bool hasBox;
  final bool hasGame;
  final bool hasPaper;
  final String? stateBox;
  final String? stateGame;
  final String? statePaper;
  final String? gameId;
  final String collectionId;
  final GameModel? game;
  final String? frontImageUrl;
  final String? backImageUrl;

  GameItemModel({
    required this.id,
    required this.hasBox,
    required this.hasGame,
    required this.hasPaper,
    this.stateBox,
    this.stateGame,
    this.statePaper,
    this.gameId,
    required this.collectionId,
    this.game,
    this.frontImageUrl,
    this.backImageUrl,
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
      'game': game?.toJson(),
      'frontImageUrl': frontImageUrl,
      'backImageUrl': backImageUrl,
    };
  }

  factory GameItemModel.fromMap(Map<String, dynamic> map) {
    return GameItemModel(
      id: map['id'] ?? '',
      hasBox: map['hasBox'] ?? false,
      hasGame: map['hasGame'] ?? false,
      hasPaper: map['hasPaper'] ?? false,
      stateBox: map['stateBox'],
      stateGame: map['stateGame'],
      statePaper: map['statePaper'],
      gameId: map['gameId'],
      collectionId: map['collectionId'] ?? '',
      game: map['game'] != null ? GameModel.fromMap(map['game']) : null,
      frontImageUrl: map['frontImageUrl'],
      backImageUrl: map['backImageUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GameItemModel.fromJson(String source) => GameItemModel.fromMap(json.decode(source));
}

extension GameCollectionItemModelExtension on GameItemModel {
  GameItemEntity toEntity() => GameItemEntity(
        id: id,
        hasBox: hasBox,
        hasGame: hasGame,
        hasPaper: hasPaper,
        stateBox: stateBox,
        stateGame: stateGame,
        statePaper: statePaper,
        gameId: gameId,
        collectionId: collectionId,
        game: game?.toEntity(),
      );
}
