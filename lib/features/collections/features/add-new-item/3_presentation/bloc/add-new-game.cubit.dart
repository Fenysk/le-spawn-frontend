import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/usecase/get-game-from-barcode.usecase.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game.state.dart';
import 'package:le_spawn_fr/service-locator.dart';

class AddNewGameCubit extends Cubit<AddNewGameState> {
  final _gameFromBarcodeUsecase = serviceLocator<GetGameFromBarcodeUsecase>();

  GameEntity? _game;

  AddNewGameCubit() : super(AddNewGameInitialState());

  Future<void> fetchGameData({String? barcode}) async {
    if (state is AddNewGameLoadingState || state is AddNewGameFailureState) return;

    if (barcode == null || barcode.isEmpty) {
      return emit(const AddNewGameFailureState(
        errorMessage: 'Barcode cannot be empty',
      ));
    }

    emit(AddNewGameLoadingState());

    final result = await _gameFromBarcodeUsecase.execute(request: barcode);

    result.fold(
      (failure) async {
        _game = null;
        emit(AddNewGameFailureState(errorMessage: failure));

        await Future.delayed(const Duration(seconds: 2), () {
          emit(AddNewGameInitialState());
        });
      },
      (gameData) {
        _game = gameData;
        emit(AddNewGameSuccessState(game: gameData));
      },
    );
  }

  void resetGame() {
    _game = null;
    emit(AddNewGameInitialState());
  }

  void confirmGame() {
    if (_game == null) {
      emit(AddNewGameInitialState());
      return;
    }
    emit(AddNewGameValidState(game: _game!));
  }
}
