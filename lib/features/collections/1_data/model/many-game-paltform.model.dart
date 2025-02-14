import 'dart:convert';
import 'package:le_spawn_frontend/features/collections/2_domain/entity/many-game-platform.entity.dart';

class ManyGamePlatformModel {
  final String gameId;
  final String platformId;

  ManyGamePlatformModel({
    required this.gameId,
    required this.platformId,
  });

  factory ManyGamePlatformModel.fromMap(Map<String, dynamic> map) {
    return ManyGamePlatformModel(
      gameId: map['gameId'] as String,
      platformId: map['platformId'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'gameId': gameId,
      'platformId': platformId,
    };
  }

  String toJson() => json.encode(toMap());
}

extension ManyGamePlatformModelExtension on ManyGamePlatformModel {
  ManyGamePlatformEntity toEntity() => ManyGamePlatformEntity(
        gameId: gameId,
        platformId: platformId,
      );
}
