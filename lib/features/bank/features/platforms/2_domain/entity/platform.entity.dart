import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';

class PlatformEntity {
  final String id;
  final int? igdbPlatformId;
  final String name;
  final String abbreviation;
  final int? generation;
  final List<GameEntity> games;

  PlatformEntity({
    required this.id,
    this.igdbPlatformId,
    required this.name,
    required this.abbreviation,
    this.generation,
    required this.games,
  });
}
