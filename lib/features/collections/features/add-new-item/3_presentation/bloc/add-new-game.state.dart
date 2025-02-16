import 'package:equatable/equatable.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';

abstract class AddNewGameState extends Equatable {
  const AddNewGameState();

  @override
  List<Object> get props => [];
}

class AddNewGameInitialState extends AddNewGameState {}

class AddNewGameLoadingState extends AddNewGameState {}

class AddNewGameSuccessState extends AddNewGameState {
  final GameEntity game;

  const AddNewGameSuccessState({required this.game});

  @override
  List<Object> get props => [
        game
      ];
}

class AddNewGameValidState extends AddNewGameState {
  final GameEntity game;

  const AddNewGameValidState({required this.game});

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
