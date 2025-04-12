import 'dart:convert';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';

class GameItemEntity {
  final String id;
  final bool hasBox;
  final bool hasGame;
  final bool hasPaper;
  final String? stateBox;
  final String? stateGame;
  final String? statePaper;
  final String? gameId;
  final GameEntity? game;
  final String collectionId;
  final String? frontImageUrl;
  final String? backImageUrl;

  GameItemEntity({
    required this.id,
    required this.hasBox,
    required this.hasGame,
    required this.hasPaper,
    this.stateBox,
    this.stateGame,
    this.statePaper,
    this.gameId,
    this.game,
    required this.collectionId,
    this.frontImageUrl,
    this.backImageUrl,
  });

  String toJson() {
    return jsonEncode({
      'id': id,
      'hasBox': hasBox,
      'hasGame': hasGame,
      'hasPaper': hasPaper,
      'stateBox': stateBox,
      'stateGame': stateGame,
      'statePaper': statePaper,
      'gameId': gameId,
      'game': game?.toJson(),
      'collectionId': collectionId,
      'frontImageUrl': frontImageUrl,
      'backImageUrl': backImageUrl,
    });
  }
}
