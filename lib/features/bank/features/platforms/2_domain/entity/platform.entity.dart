import 'package:le_spawn_frontend/features/collections/2_domain/entity/many-game-platform.entity.dart';

class PlatformEntity {
  final String id;
  final int? igdbPlatformId;
  final String name;
  final String abbreviation;
  final int? generation;
  final List<ManyGamePlatformEntity> gamesRelation;

  PlatformEntity({
    required this.id,
    this.igdbPlatformId,
    required this.name,
    required this.abbreviation,
    this.generation,
    required this.gamesRelation,
  });
}