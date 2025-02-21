import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/features/reports/1_data/dto/create-game-report.dto.dart';
import 'package:le_spawn_fr/features/reports/2_domain/repository/reports.repository.dart';
import 'package:le_spawn_fr/features/reports/3_presentation/bloc/report-game.state.dart';
import 'package:le_spawn_fr/core/di/service-locator.dart';

class ReportGameCubit extends Cubit<ReportGameState> {
  ReportGameCubit() : super(const ReportGameInitialState());

  Future<void> submitReport(String gameId, String explication) async {
    emit(const ReportGameLoadingState());

    final result = await serviceLocator<ReportsRepository>().createGameReport(
      CreateGameReportDto(
        gameId: gameId,
        explication: explication,
      ),
    );

    result.fold(
      (error) => emit(ReportGameFailureState(errorMessage: error)),
      (report) => emit(ReportGameSuccessState(report: report)),
    );
  }
}
