import 'dart:convert';
import 'package:le_spawn_fr/features/bank/2_domain/entity/region.entity.dart';

class GameLocalizationEntity {
  final String id;
  final String? name;
  final String? coverUrl;
  final String regionId;
  final RegionEntity region;
  final String gameId;

  GameLocalizationEntity({
    required this.id,
    this.name,
    this.coverUrl,
    required this.regionId,
    required this.region,
    required this.gameId,
  });

  String toJson() {
    return jsonEncode({
      'id': id,
      'name': name,
      'coverUrl': coverUrl,
      'regionId': regionId,
      'region': region.toJson(),
      'gameId': gameId,
    });
  }
}
