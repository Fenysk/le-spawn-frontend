import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/core/utils/debouce.util.dart';
import 'package:le_spawn_fr/features/bank/features/games/1_data/dto/search-games.request.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/usecase/seach-games-from-barcode.usecase.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/usecase/search-games-in-bank.usecase.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/usecase/search-games-in-provider.usecase.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/1_data/dto/add-barcode-to-game.request.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/2_domain/usecase/add-barcode-to-game.usecase.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game.state.dart';
import 'package:le_spawn_fr/service-locator.dart';

class AddNewGameCubit extends Cubit<AddNewGameState> {
  List<GameEntity> _fetchedGames = [];
  GameEntity? _selectedGame;
  String? _selectedBarcode;

  final Debouncer _debouncer = Debouncer();

  AddNewGameCubit() : super(AddNewGameInitialState());

  Future<void> fetchGamesFromBarcode({String? barcode}) async {
    if (state is AddNewGameLoadingState || state is AddNewGameFailureState) return;

    if (barcode == null || barcode.isEmpty) {
      return emit(const AddNewGameFailureState(errorMessage: 'Barcode cannot be empty'));
    }

    emit(AddNewGameLoadingState());

    _selectedBarcode = barcode;

    final result = await serviceLocator<SearchGamesFromBarcodeUsecase>().execute(request: SearchGamesRequest(barcode: barcode));

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

  void searchGames(String query) {
    _debouncer.run(() async {
      emit(AddNewGameLoadingState());

      final bankResult = await serviceLocator<SearchGamesInBankUsecase>().execute(request: SearchGamesRequest(query: query));

      bankResult.fold(
        (failure) async {
          final providersResult = await serviceLocator<SearchGamesInProvidersUsecase>().execute(request: SearchGamesRequest(query: query));

          providersResult.fold(
            (failure) {
              emit(AddNewGameFailureState(errorMessage: failure));
            },
            (games) {
              _fetchedGames = games;
              emit(AddNewGameLoadedGamesState(games: games));
            },
          );
        },
        (games) {
          _fetchedGames = games;
          emit(AddNewGameLoadedGamesState(games: games));
        },
      );
    });
  }

  @override
  Future<void> close() {
    _debouncer.dispose();
    return super.close();
  }

  void resetGame() {
    _selectedGame = null;
    _selectedBarcode = null;
    emit(AddNewGameInitialState());
  }

  void confirmGame(String gameId) async {
    _selectedGame = _fetchedGames.firstWhere((game) => game.id == gameId);

    final shouldAddBarcode = _selectedGame != null && _selectedBarcode != null && _selectedGame!.barcodes.isEmpty;

    if (shouldAddBarcode) {
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
