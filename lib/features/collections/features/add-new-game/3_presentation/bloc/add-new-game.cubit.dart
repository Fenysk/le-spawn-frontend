import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_frontend/features/bank/features/games/2_domain/usecase/get-game-from-barcode.usecase.dart';
import 'package:le_spawn_frontend/features/collections/features/add-new-game/3_presentation/bloc/add-new-game.state.dart';
import 'package:le_spawn_frontend/service-locator.dart';

class AddNewGameCubit extends Cubit<AddNewGameState> {
  AddNewGameCubit() : super(AddNewGameInitialState());

  Future<void> fetchGameData({
    String? barcode,
  }) async {
    emit(AddNewGameLoadingState());
    final result = await serviceLocator<GetGameFromBarcodeUsecase>().execute(request: barcode);
    result.fold(
      (failure) => emit(AddNewGameFailureState(errorMessage: failure)),
      (gameData) => emit(AddNewGameSuccessState(game: gameData)),
    );
  }
}
