import 'package:le_spawn_frontend/features/collections/2_domain/entity/game-item.entity.dart';

class CollectionEntity {
  final String id;
  final String title;
  final List<GameCollectionItemEntity> gameItems;
  final String userId;

  CollectionEntity({
    required this.id,
    required this.title,
    required this.gameItems,
    required this.userId,
  });
}
