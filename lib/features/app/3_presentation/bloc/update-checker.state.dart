part of 'update-checker.cubit.dart';

abstract class UpdateCheckerState extends Equatable {
  const UpdateCheckerState();

  @override
  List<Object?> get props => [];
}

class UpdateCheckerInitialState extends UpdateCheckerState {}

class UpdateCheckerLoadingState extends UpdateCheckerState {}

class UpdateCheckerGoodVersionState extends UpdateCheckerState {}

class UpdateCheckerNeedUpdateState extends UpdateCheckerState {
  final String message;

  const UpdateCheckerNeedUpdateState({required this.message});

  @override
  List<Object?> get props => [
        message
      ];
}
