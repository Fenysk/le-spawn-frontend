import 'dart:convert';
import 'package:le_spawn_fr/features/bank/features/games/1_data/model/region.model.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game-localization.entity.dart';

class GameLocalizationModel {
  final String id;
  final String? name;
  final String? coverUrl;
  final String regionId;
  final RegionModel region;
  final String gameId;

  GameLocalizationModel({
    required this.id,
    this.name,
    this.coverUrl,
    required this.regionId,
    required this.region,
    required this.gameId,
  });

  String toJson() => json.encode({
        'id': id,
        'name': name,
        'coverUrl': coverUrl,
        'regionId': regionId,
        'region': region.toJson(),
        'gameId': gameId,
      });

  factory GameLocalizationModel.fromMap(Map<String, dynamic> map) {
    return GameLocalizationModel(
      id: map['id'],
      name: map['name'],
      coverUrl: map['coverUrl'],
      regionId: map['regionId'],
      region: RegionModel.fromMap(map['region'] as Map<String, dynamic>),
      gameId: map['gameId'],
    );
  }

  factory GameLocalizationModel.fromJson(String source) => GameLocalizationModel.fromMap(json.decode(source));

  GameLocalizationEntity toEntity() => GameLocalizationEntity(
        id: id,
        name: name,
        coverUrl: coverUrl,
        regionId: regionId,
        region: region.toEntity(),
        gameId: gameId,
      );
}
