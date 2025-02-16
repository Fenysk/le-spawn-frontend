import 'dart:convert';
import 'package:le_spawn_fr/features/collections/1_data/model/game-item.model.dart';
import 'package:le_spawn_fr/features/collections/2_domain/entity/collection.entity.dart';

class CollectionModel {
  final String id;
  final String title;
  final List<GameItemModel> gameItems;
  final String userId;

  CollectionModel({
    required this.id,
    required this.title,
    required this.gameItems,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'gamesItems': gameItems.map((item) => item.toMap()).toList(),
      'userId': userId,
    };
  }

  String toJson() => json.encode(toMap());

  factory CollectionModel.fromJson(String source) => CollectionModel.fromMap(json.decode(source));

  factory CollectionModel.fromMap(Map<String, dynamic> map) {
    return CollectionModel(
      id: map['id'],
      title: map['title'],
      gameItems: List<GameItemModel>.from(map['gameItems']?.map((x) => GameItemModel.fromMap(x)) ?? []),
      userId: map['userId'],
    );
  }
}

extension CollectionModelExtension on CollectionModel {
  CollectionEntity toEntity() => CollectionEntity(
        id: id,
        title: title,
        gameItems: gameItems.map((item) => item.toEntity()).toList(),
        userId: userId,
      );
}
