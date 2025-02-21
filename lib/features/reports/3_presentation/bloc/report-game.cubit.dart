import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/features/reports/1_data/dto/create-game-report.dto.dart';
import 'package:le_spawn_fr/features/reports/2_domain/repository/reports.repository.dart';
import 'package:le_spawn_fr/features/reports/3_presentation/bloc/report-game.state.dart';
import 'package:le_spawn_fr/core/di/service-locator.dart';

class ReportGameCubit extends Cubit<ReportGameState> {
  ReportGameCubit() : super(const ReportGameInitialState());

  Future<void> submitReport(String gameId, String explication) async {
    emit(const ReportGameLoadingState());

    developer.log('Submitting report with gameId: $gameId and explication: $explication');

    final dto = CreateGameReportDto(
      gameId: gameId,
      explication: explication,
    );

    developer.log('DTO JSON: ${dto.toJson()}');

    final result = await serviceLocator<ReportsRepository>().createGameReport(dto);

    result.fold(
      (error) {
        developer.log('Error submitting report: $error');
        emit(ReportGameFailureState(errorMessage: error));
      },
      (_) {
        developer.log('Report submitted successfully');
        emit(const ReportGameSuccessState());
      },
    );
  }
}
