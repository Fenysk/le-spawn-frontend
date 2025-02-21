import 'package:equatable/equatable.dart';

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
  const ReportGameSuccessState();
}

class ReportGameFailureState extends ReportGameState {
  final String errorMessage;

  const ReportGameFailureState({required this.errorMessage});

  @override
  List<Object?> get props => [
        errorMessage
      ];
}
