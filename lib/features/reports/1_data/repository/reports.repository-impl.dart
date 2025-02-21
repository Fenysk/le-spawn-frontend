import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/features/reports/1_data/dto/create-game-report.dto.dart';
import 'package:le_spawn_fr/features/reports/1_data/model/game-report.model.dart';
import 'package:le_spawn_fr/features/reports/1_data/source/reports-api.service.dart';
import 'package:le_spawn_fr/features/reports/2_domain/entity/game-report.entity.dart';
import 'package:le_spawn_fr/features/reports/2_domain/repository/reports.repository.dart';
import 'package:le_spawn_fr/core/di/service-locator.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  @override
  Future<Either<String, GameReportEntity>> createGameReport(CreateGameReportDto dto) async {
    Either<String, dynamic> response = await serviceLocator<ReportsApiService>().createGameReport(dto.gameId, dto.toJson());

    return response.fold(
      (error) => Left(error),
      (data) {
        GameReportModel report = GameReportModel.fromMap(data);
        return Right(report.toEntity());
      },
    );
  }

  @override
  Future<Either<String, List<GameReportEntity>>> getGameReports(String gameId) async {
    Either<String, List<dynamic>> response = await serviceLocator<ReportsApiService>().getGameReports(gameId);

    return response.fold(
      (error) => Left(error),
      (data) {
        List<GameReportModel> reports = data.map((item) => GameReportModel.fromMap(item)).toList();
        List<GameReportEntity> reportEntities = reports.map((model) => model.toEntity()).toList();
        return Right(reportEntities);
      },
    );
  }

  @override
  Future<Either<String, List<GameReportEntity>>> getMyReports() async {
    Either<String, List<dynamic>> response = await serviceLocator<ReportsApiService>().getMyReports();

    return response.fold(
      (error) => Left(error),
      (data) {
        List<GameReportModel> reports = data.map((item) => GameReportModel.fromMap(item)).toList();
        List<GameReportEntity> reportEntities = reports.map((model) => model.toEntity()).toList();
        return Right(reportEntities);
      },
    );
  }

  @override
  Future<Either<String, GameReportEntity>> updateReportStatus(String reportId, String status) async {
    Either<String, dynamic> response = await serviceLocator<ReportsApiService>().updateReportStatus(reportId, status);

    return response.fold(
      (error) => Left(error),
      (data) {
        GameReportModel report = GameReportModel.fromMap(data);
        return Right(report.toEntity());
      },
    );
  }
}
