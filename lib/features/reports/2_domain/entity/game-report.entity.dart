import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';
import 'package:le_spawn_fr/features/user/2_domain/entity/user.entity.dart';

class GameReportEntity {
  final String id;
  final String explication;
  final String status;
  final GameEntity game;
  final UserEntity reporter;
  final DateTime createdAt;
  final DateTime updatedAt;

  GameReportEntity({
    required this.id,
    required this.explication,
    required this.status,
    required this.game,
    required this.reporter,
    required this.createdAt,
    required this.updatedAt,
  });
}
