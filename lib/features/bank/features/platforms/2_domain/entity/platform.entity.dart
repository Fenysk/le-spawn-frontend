import 'dart:convert';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';

class PlatformEntity {
  final String id;
  final int? igdbPlatformId;
  final String name;
  final String? abbreviation;
  final int? generation;
  final List<GameEntity>? games;
  final String? logoUrl;

  PlatformEntity({
    required this.id,
    this.igdbPlatformId,
    required this.name,
    this.abbreviation,
    this.generation,
    this.games,
    this.logoUrl,
  });

  String toJson() {
    return jsonEncode({
      'id': id,
      'igdbPlatformId': igdbPlatformId,
      'name': name,
      'abbreviation': abbreviation,
      'generation': generation,
      'games': games?.map((game) => game.toJson()).toList(),
      'logoUrl': logoUrl,
    });
  }
}
