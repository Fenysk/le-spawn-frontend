import 'package:equatable/equatable.dart';
import 'package:le_spawn_fr/features/reports/2_domain/entity/game-report.entity.dart';

abstract class ReportGameState extends Equatable {
  const ReportGameState();

  @override
  List<Object?> get props => [];
}

class ReportGameInitialState extends ReportGameState {
  const ReportGameInitialState();
}

class ReportGameLoadingState extends ReportGameState {
  const ReportGameLoadingState();
}

class ReportGameSuccessState extends ReportGameState {
  final GameReportEntity report;

  const ReportGameSuccessState({required this.report});

  @override
  List<Object?> get props => [
        report
      ];
}

class ReportGameFailureState extends ReportGameState {
  final String errorMessage;

  const ReportGameFailureState({required this.errorMessage});

  @override
  List<Object?> get props => [
        errorMessage
      ];
}
