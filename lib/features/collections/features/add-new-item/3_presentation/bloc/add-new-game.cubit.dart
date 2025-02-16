import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/usecase/get-game-from-barcode.usecase.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/1_data/dto/add-barcode-to-game.request.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/2_domain/repository/new-item.repository.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/2_domain/usecase/add-barcode-to-game.usecase.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game.state.dart';
import 'package:le_spawn_fr/service-locator.dart';

class AddNewGameCubit extends Cubit<AddNewGameState> {
  List<GameEntity> _fetchedGames = [];
  GameEntity? _selectedGame;
  String? _selectedBarcode;

  AddNewGameCubit() : super(AddNewGameInitialState());

  Future<void> fetchGameData({String? barcode}) async {
    if (state is AddNewGameLoadingState || state is AddNewGameFailureState) return;

    if (barcode == null || barcode.isEmpty) {
      return emit(const AddNewGameFailureState(errorMessage: 'Barcode cannot be empty'));
    }

    emit(AddNewGameLoadingState());

    _selectedBarcode = barcode;

    final result = await serviceLocator<GetGamesFromBarcodeUsecase>().execute(request: barcode);

    result.fold(
      (failure) async {
        _selectedGame = null;
        emit(AddNewGameFailureState(errorMessage: failure));

        await Future.delayed(const Duration(seconds: 2), () {
          emit(AddNewGameInitialState());
        });
      },
      (games) {
        _fetchedGames = games;
        emit(AddNewGameLoadedGamesState(games: games));
      },
    );
  }

  void resetGame() {
    _selectedGame = null;
    _selectedBarcode = null;
    emit(AddNewGameInitialState());
  }

  void confirmGame(String gameId) async {
    _selectedGame = _fetchedGames.firstWhere((game) => game.id == gameId);

    if (_selectedBarcode == null) {
      return emit(AddNewGameFailureState(errorMessage: 'No barcode selected'));
    }

    if (_selectedGame != null && _selectedGame!.barcodes.isEmpty) {
      await serviceLocator<AddBarcodeToGameUsecase>().execute(
        request: AddBarcodeToGameRequest(
          gameId: gameId,
          barcode: _selectedBarcode!,
        ),
      );
    }

    emit(AddNewGameItemInfoState(game: _selectedGame!));
  }
}
