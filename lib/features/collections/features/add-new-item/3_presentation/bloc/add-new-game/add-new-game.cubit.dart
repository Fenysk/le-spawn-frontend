import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/core/utils/debouce.util.dart';
import 'package:le_spawn_fr/features/bank/features/games/1_data/dto/get-games-from-images-request.dto.dart';
import 'package:le_spawn_fr/features/bank/features/games/1_data/dto/search-games.request.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/usecase/fetch-games-from-images.usecase.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/usecase/seach-games-from-barcode.usecase.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/usecase/search-games-in-bank.usecase.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/usecase/search-games-in-provider.usecase.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/1_data/dto/add-barcode-to-game.request.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/2_domain/usecase/add-barcode-to-game.usecase.dart';
import 'package:le_spawn_fr/features/storage/2_domain/repository/storage.repository.dart';
import 'package:le_spawn_fr/core/di/service-locator.dart';
import 'package:flutter/foundation.dart';
import 'add-new-game.state.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/game-search/game-search.cubit.dart';

class AddNewGameCubit extends Cubit<AddNewGameState> {
  final GameSearchCubit _gameSearchCubit;
  GameEntity? _selectedGame;
  String? _selectedBarcode;

  final Debouncer _debouncer = Debouncer();

  AddNewGameCubit(this._gameSearchCubit) : super(AddNewGameInitialState());

  void startScanning() {
    emit(AddNewGameScanningState());
  }

  void startPhotoCapture({String? barcode}) {
    emit(AddNewGameCapturingPhotoState(barcode: barcode));
  }

  Future<void> fetchGamesFromBarcode({String? barcode}) async {
    if (state is AddNewGameLoadingState || state is AddNewGameFailureState) return;

    if (barcode == null || barcode.isEmpty) {
      return emit(AddNewGameFailureState(
        errorMessage: 'Barcode cannot be empty',
      ));
    }

    emit(AddNewGameLoadingState(barcode: barcode));

    _selectedBarcode = barcode;

    final result = await serviceLocator<SearchGamesFromBarcodeUsecase>().execute(
      request: SearchGamesRequest(barcode: barcode),
    );

    result.fold(
      (failure) {
        debugPrint('🔍 Failure received: $failure');
        if (failure.contains('404')) {
          debugPrint('📱 Emitting NoResultState for barcode: $barcode');
          emit(AddNewGameNoResultState(barcode: barcode));
        } else {
          debugPrint('❌ Emitting FailureState: $failure');
          emit(AddNewGameFailureState(
            errorMessage: failure,
            barcode: barcode,
          ));
        }
      },
      (games) {
        debugPrint('✅ Games found: ${games.length}');
        emit(AddNewGameLoadedGamesState(
          games: games,
          barcode: barcode,
        ));
      },
    );
  }

  Future<void> searchGamesFromImage(File imageFile, String? barcode) async {
    debugPrint('🔍 Starting image search with barcode: $barcode');
    emit(AddNewGameUploadingPhotoState(barcode: barcode));

    try {
      debugPrint('📤 Uploading image to storage...');
      final uploadResult = await serviceLocator<StorageRepository>().uploadFile(imageFile);

      final uploadedFile = uploadResult.fold(
        (error) {
          debugPrint('❌ Error uploading image: $error');
          throw Exception(error);
        },
        (file) => file,
      );

      debugPrint('✅ Image uploaded successfully: ${uploadedFile.url}');

      debugPrint('🔍 Searching games with image and barcode: $barcode');
      final result = await serviceLocator<FetchGamesFromImagesUsecase>().execute(
        request: GetGamesFromImagesRequest(
          images: [
            uploadedFile.url
          ],
          barcode: barcode,
        ),
      );

      result.fold(
        (error) {
          debugPrint('❌ Failed to find games from image: $error');
          if (error.contains('404')) {
            debugPrint('⚠️ No games found for barcode: $barcode');
            emit(AddNewGameNoResultState(barcode: barcode));
          } else {
            emit(AddNewGameFailureState(
              errorMessage: 'Erreur lors de la recherche : $error',
              barcode: barcode,
            ));
          }
        },
        (games) {
          debugPrint('✅ Found ${games.length} games from image');
          if (games.isEmpty) {
            debugPrint('⚠️ No games found for barcode: $barcode');
            emit(AddNewGameNoResultState(barcode: barcode));
          } else {
            emit(AddNewGameLoadedGamesState(
              games: games,
              barcode: barcode,
            ));
          }
        },
      );
    } catch (e) {
      debugPrint('❌ Error during image search: $e');
      emit(AddNewGameFailureState(
        errorMessage: 'Une erreur est survenue lors de la recherche',
        barcode: barcode,
      ));
    }
  }

  void searchGamesFromQuery(String query) {
    _debouncer.run(() async {
      emit(AddNewGameLoadingState());

      final bankResult = await serviceLocator<SearchGamesInBankUsecase>().execute(
        request: SearchGamesRequest(query: query),
      );

      bankResult.fold(
        (failure) async {
          final providersResult = await serviceLocator<SearchGamesInProvidersUsecase>().execute(
            request: SearchGamesRequest(query: query),
          );

          providersResult.fold(
            (failure) {
              emit(AddNewGameFailureState(errorMessage: failure));
            },
            (games) {
              emit(AddNewGameLoadedGamesState(games: games));
            },
          );
        },
        (games) {
          emit(AddNewGameLoadedGamesState(games: games));
        },
      );
    });
  }

  void resetGame() {
    _selectedGame = null;
    _selectedBarcode = null;
    emit(AddNewGameInitialState());
    _gameSearchCubit.reset();
  }

  void selectGame(GameEntity game) {
    _selectedGame = game;
    emit(AddNewGameConfirmationGameState(game: game));
  }

  void confirmGame(String gameId) async {
    try {
      if (_selectedGame == null) {
        debugPrint('❌ No game selected');
        return emit(AddNewGameFailureState(
          errorMessage: 'Aucun jeu sélectionné',
        ));
      }

      debugPrint('🎮 Confirming game: ${_selectedGame?.name} (ID: $gameId)');

      final shouldAddBarcode = _selectedGame != null && _selectedBarcode != null && !_selectedGame!.barcodes.contains(_selectedBarcode);

      if (shouldAddBarcode) {
        debugPrint('📝 Adding barcode ${_selectedBarcode!} to game $gameId');
        final result = await serviceLocator<AddBarcodeToGameUsecase>().execute(
          request: AddBarcodeToGameRequest(
            gameId: gameId,
            barcode: _selectedBarcode!,
          ),
        );

        await result.fold(
          (error) {
            debugPrint('❌ Error adding barcode: $error');
            emit(AddNewGameFailureState(
              errorMessage: 'Erreur lors de l\'ajout du code-barre : $error',
              barcode: _selectedBarcode!,
            ));
            return;
          },
          (updatedGame) {
            debugPrint('✅ Barcode added successfully');
            _selectedGame = updatedGame;
          },
        );
      }

      emit(AddNewGameItemInfoState(game: _selectedGame!));
    } catch (e) {
      debugPrint('❌ Error during game confirmation: $e');
      emit(AddNewGameFailureState(
        errorMessage: 'Une erreur est survenue lors de la confirmation du jeu',
        barcode: _selectedBarcode ?? '',
      ));
    }
  }

  void setSuccess(GameEntity game) {
    emit(AddNewGameSuccessState(game: game));
  }

  @override
  Future<void> close() {
    _debouncer.dispose();
    return super.close();
  }
}
