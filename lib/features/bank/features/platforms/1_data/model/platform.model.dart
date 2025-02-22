import 'dart:convert';

import 'package:le_spawn_fr/features/bank/features/games/1_data/model/game.model.dart';
import 'package:le_spawn_fr/features/bank/features/platforms/2_domain/entity/platform.entity.dart';

class PlatformModel {
  final String id;
  final int? igdbPlatformId;
  final String name;
  final String? abbreviation;
  final int? generation;
  final List<GameModel>? games;

  PlatformModel({
    required this.id,
    this.igdbPlatformId,
    required this.name,
    this.abbreviation,
    this.generation,
    this.games,
  });

  factory PlatformModel.fromMap(Map<String, dynamic> map) {
    return PlatformModel(
      id: map['id'] as String,
      igdbPlatformId: map['igdbPlatformId'] as int?,
      name: map['name'] as String,
      abbreviation: map['abbreviation'] as String?,
      generation: map['generation'] as int?,
      games: map['games'] != null
          ? List<GameModel>.from(
              (map['games'] as List<dynamic>).map(
                (x) => GameModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'igdbPlatformId': igdbPlatformId,
      'name': name,
      'abbreviation': abbreviation,
      'generation': generation,
      'games': games?.map((game) => game.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  factory PlatformModel.fromJson(String source) => PlatformModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

extension PlatformModelExtension on PlatformModel {
  PlatformEntity toEntity() => PlatformEntity(
        id: id,
        igdbPlatformId: igdbPlatformId,
        name: name,
        abbreviation: abbreviation,
        generation: generation,
        games: games?.map((game) => game.toEntity()).toList(),
      );
}
