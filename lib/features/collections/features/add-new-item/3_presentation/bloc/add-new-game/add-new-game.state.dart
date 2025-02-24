import 'package:equatable/equatable.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';

sealed class AddNewGameState extends Equatable {
  final String? barcode;

  const AddNewGameState({this.barcode});

  @override
  List<Object?> get props => [
        barcode
      ];
}

class AddNewGameInitialState extends AddNewGameState {
  const AddNewGameInitialState() : super();
}

class AddNewGameScanningState extends AddNewGameState {
  const AddNewGameScanningState() : super();
}

class AddNewGameLoadingState extends AddNewGameState {
  const AddNewGameLoadingState({super.barcode});
}

class AddNewGameLoadedGamesState extends AddNewGameState {
  final List<GameEntity> games;

  const AddNewGameLoadedGamesState({
    required this.games,
    super.barcode,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        games
      ];
}

class AddNewGameFailureState extends AddNewGameState {
  final String errorMessage;

  const AddNewGameFailureState({
    required this.errorMessage,
    super.barcode,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        errorMessage
      ];
}

class AddNewGameNoResultState extends AddNewGameState {
  const AddNewGameNoResultState({super.barcode});
}

class AddNewGameCapturingPhotoState extends AddNewGameState {
  const AddNewGameCapturingPhotoState({super.barcode});
}

class AddNewGameUploadingPhotoState extends AddNewGameState {
  final double? progress;

  const AddNewGameUploadingPhotoState({
    super.barcode,
    this.progress,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        progress
      ];
}

class AddNewGameConfirmationGameState extends AddNewGameState {
  final GameEntity game;

  const AddNewGameConfirmationGameState({
    required this.game,
    super.barcode,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        game
      ];
}

class AddNewGameItemInfoState extends AddNewGameState {
  final GameEntity game;

  const AddNewGameItemInfoState({
    required this.game,
    super.barcode,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        game
      ];
}

class AddNewGameSuccessState extends AddNewGameState {
  final GameEntity game;

  const AddNewGameSuccessState({
    required this.game,
    super.barcode,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        game
      ];
}
