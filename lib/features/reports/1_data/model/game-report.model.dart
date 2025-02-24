import 'dart:convert';
import 'package:le_spawn_fr/features/bank/features/games/1_data/model/game.model.dart';
import 'package:le_spawn_fr/features/reports/2_domain/entity/game-report.entity.dart';
import 'package:le_spawn_fr/features/user/1_data/model/user.model.dart';

class GameReportModel {
  final String id;
  final String explication;
  final String status;
  final GameModel game;
  final UserModel reporter;
  final DateTime createdAt;
  final DateTime updatedAt;

  GameReportModel({
    required this.id,
    required this.explication,
    required this.status,
    required this.game,
    required this.reporter,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'explication': explication,
      'status': status,
      'game': game.toJson(),
      'reporter': reporter.toMap(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory GameReportModel.fromMap(Map<String, dynamic> map) {
    return GameReportModel(
      id: map['id'],
      explication: map['explication'],
      status: map['status'],
      game: GameModel.fromMap(map['game']),
      reporter: UserModel.fromMap(map['reporter']),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory GameReportModel.fromJson(String source) => GameReportModel.fromMap(json.decode(source));
}

extension GameReportModelExtension on GameReportModel {
  GameReportEntity toEntity() => GameReportEntity(
        id: id,
        explication: explication,
        status: status,
        game: game.toEntity(),
        reporter: reporter.toEntity(),
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
