
import 'dart:convert';

import 'package:le_spawn_frontend/features/bank/platforms/2_domain/entity/platform.entity.dart';
import 'package:le_spawn_frontend/features/collections/1_data/model/many-game-paltform.model.dart';

class PlatformModel {
  final String id;
  final int? igdbPlatformId;
  final String name;
  final String abbreviation;
  final int? generation;
  final List<ManyGamePlatformModel> gamesRelation;

  PlatformModel({
    required this.id,
    this.igdbPlatformId,
    required this.name,
    required this.abbreviation,
    this.generation,
    required this.gamesRelation,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'igdbPlatformId': igdbPlatformId,
      'name': name,
      'abbreviation': abbreviation,
      'generation': generation,
      'gamesRelation':
          gamesRelation.map((relation) => relation.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());
}

extension PlatformModelExtension on PlatformModel {
  PlatformEntity toEntity() => PlatformEntity(
        id: id,
        igdbPlatformId: igdbPlatformId,
        name: name,
        abbreviation: abbreviation,
        generation: generation,
        gamesRelation:
            gamesRelation.map((relation) => relation.toEntity()).toList(),
      );
}
