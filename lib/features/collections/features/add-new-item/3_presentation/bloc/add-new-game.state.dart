import 'package:equatable/equatable.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';

abstract class AddNewGameState extends Equatable {
  const AddNewGameState();

  @override
  List<Object> get props => [];
}

class AddNewGameInitialState extends AddNewGameState {}

class AddNewGameLoadingState extends AddNewGameState {}

class AddNewGameLoadedGamesState extends AddNewGameState {
  final List<GameEntity> games;

  const AddNewGameLoadedGamesState({required this.games});

  @override
  List<Object> get props => [
        games
      ];
}

class AddNewGameItemInfoState extends AddNewGameState {
  final GameEntity game;

  const AddNewGameItemInfoState({required this.game});

  @override
  List<Object> get props => [
        game
      ];
}

class AddNewGameFailureState extends AddNewGameState {
  final String errorMessage;

  const AddNewGameFailureState({required this.errorMessage});

  @override
  List<Object> get props => [
        errorMessage
      ];
}
