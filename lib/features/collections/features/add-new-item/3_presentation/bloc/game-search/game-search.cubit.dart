import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:le_spawn_fr/core/utils/debouce.util.dart';
import 'package:le_spawn_fr/features/bank/features/games/1_data/dto/get-games-from-images-request.dto.dart';
import 'package:le_spawn_fr/features/bank/features/games/1_data/dto/search-games.request.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/usecase/fetch-games-from-images.usecase.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/usecase/seach-games-from-barcode.usecase.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/usecase/search-games-in-bank.usecase.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/usecase/search-games-in-provider.usecase.dart';
import 'package:le_spawn_fr/features/storage/2_domain/repository/storage.repository.dart';
import 'package:le_spawn_fr/core/di/service-locator.dart';
import 'game-search.state.dart';

class GameSearchCubit extends Cubit<GameSearchState> {
  List<GameEntity> _fetchedGames = [];
  final Debouncer _debouncer = Debouncer();

  GameSearchCubit() : super(GameSearchInitialState());

  void startScanning() {
    emit(GameSearchScanningState());
  }

  void startPhotoCapture({String? barcode}) {
    emit(GameSearchCapturingPhotoState(barcode: barcode));
  }

  Future<void> fetchGamesFromBarcode({String? barcode}) async {
    if (state is GameSearchLoadingState || state is GameSearchFailureState) return;

    if (barcode == null || barcode.isEmpty) {
      return emit(GameSearchFailureState(
        errorMessage: 'Barcode cannot be empty',
      ));
    }

    emit(GameSearchLoadingState(barcode: barcode));

    final result = await serviceLocator<SearchGamesFromBarcodeUsecase>().execute(
      request: SearchGamesRequest(barcode: barcode),
    );

    result.fold(
      (failure) {
        debugPrint('🔍 Failure received: $failure');
        if (failure.contains('404')) {
          debugPrint('📱 Emitting NoResultState for barcode: $barcode');
          emit(GameSearchNoResultState(barcode: barcode));
        } else {
          debugPrint('❌ Emitting FailureState: $failure');
          emit(GameSearchFailureState(
            errorMessage: failure,
            barcode: barcode,
          ));
        }
      },
      (games) {
        debugPrint('✅ Games found: ${games.length}');
        _fetchedGames = games;
        emit(GameSearchLoadedGamesState(
          games: games,
          barcode: barcode,
        ));
      },
    );
  }

  Future<void> searchGamesFromImage(File imageFile, String? barcode) async {
    debugPrint('🔍 Starting image search with barcode: $barcode');
    emit(GameSearchUploadingPhotoState(barcode: barcode));

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
          emit(GameSearchNoResultState(barcode: barcode));
        },
        (games) {
          debugPrint('✅ Found ${games.length} games from image');
          if (games.isEmpty) {
            debugPrint('⚠️ No games found');
            emit(GameSearchNoResultState(barcode: barcode));
          } else {
            _fetchedGames = games;
            emit(GameSearchLoadedGamesState(
              games: games,
              barcode: barcode,
            ));
          }
        },
      );
    } catch (e) {
      debugPrint('❌ Error during image search: $e');
      emit(GameSearchFailureState(
        errorMessage: 'Une erreur est survenue lors de la recherche',
        barcode: barcode,
      ));
    }
  }

  void searchGamesFromQuery(String query) {
    _debouncer.run(() async {
      emit(GameSearchLoadingState());

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
              emit(GameSearchFailureState(errorMessage: failure));
            },
            (games) {
              _fetchedGames = games;
              emit(GameSearchLoadedGamesState(games: games));
            },
          );
        },
        (games) {
          _fetchedGames = games;
          emit(GameSearchLoadedGamesState(games: games));
        },
      );
    });
  }

  void reset() {
    _fetchedGames = [];
    emit(GameSearchInitialState());
  }

  GameEntity? getGameById(String gameId) {
    return _fetchedGames.firstWhere((game) => game.id == gameId);
  }

  @override
  Future<void> close() {
    _debouncer.dispose();
    return super.close();
  }
}
