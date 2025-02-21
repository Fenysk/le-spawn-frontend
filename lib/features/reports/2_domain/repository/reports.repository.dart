import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/features/reports/1_data/dto/create-game-report.dto.dart';
import 'package:le_spawn_fr/features/reports/2_domain/entity/game-report.entity.dart';

abstract class ReportsRepository {
  Future<Either<String, void>> createGameReport(CreateGameReportDto dto);
  Future<Either<String, List<GameReportEntity>>> getGameReports(String gameId);
  Future<Either<String, List<GameReportEntity>>> getMyReports();
  Future<Either<String, GameReportEntity>> updateReportStatus(String reportId, String status);
}
