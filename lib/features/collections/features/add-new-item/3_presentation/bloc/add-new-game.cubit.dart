import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/usecase/get-game-from-barcode.usecase.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game.state.dart';
import 'package:le_spawn_fr/service-locator.dart';

class AddNewGameCubit extends Cubit<AddNewGameState> {
  AddNewGameCubit() : super(AddNewGameInitialState());

  GameEntity? game;

  Future<void> fetchGameData({
    String? barcode,
  }) async {
    emit(AddNewGameLoadingState());
    final result = await serviceLocator<GetGameFromBarcodeUsecase>().execute(request: barcode);

    game = result.fold(
      (failure) => null,
      (gameData) => gameData,
    );

    result.fold(
      (failure) => emit(AddNewGameFailureState(errorMessage: failure)),
      (gameData) => emit(AddNewGameSuccessState(game: gameData)),
    );
  }

  Future<void> resetGame() async {
    if (game == null) return emit(AddNewGameInitialState());
    emit(AddNewGameInitialState());
  }

  Future<void> confirmGame() async {
    if (game == null) return emit(AddNewGameInitialState());
    emit(AddNewGameValidState(game: game!));
  }
}
