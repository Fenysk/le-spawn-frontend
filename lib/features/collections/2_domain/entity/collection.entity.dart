import 'dart:convert';
import 'package:le_spawn_fr/features/collections/2_domain/entity/game-item.entity.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';

class CollectionEntity {
  final String id;
  final String title;
  final List<GameItemEntity> gameItems;
  final String userId;

  CollectionEntity({
    required this.id,
    required this.title,
    required this.gameItems,
    required this.userId,
  });

  factory CollectionEntity.empty() => CollectionEntity(
        id: '',
        title: '',
        gameItems: [],
        userId: '',
      );

  List<GameEntity> getLastGames({int? limit}) => limit == null ? gameItems.map((gameItem) => gameItem.game).toList() : gameItems.take(limit).map((gameItem) => gameItem.game).toList();

  CollectionEntity sortGamesByTitle() {
    final sortedGameItems = gameItems..sort((a, b) => a.game.name.compareTo(b.game.name));

    return CollectionEntity(
      id: id,
      title: title,
      gameItems: sortedGameItems,
      userId: userId,
    );
  }

  String toJson() {
    return jsonEncode({
      'id': id,
      'title': title,
      'gameItems': gameItems.map((gameItem) => gameItem.toJson()).toList(),
      'userId': userId,
    });
  }
}
