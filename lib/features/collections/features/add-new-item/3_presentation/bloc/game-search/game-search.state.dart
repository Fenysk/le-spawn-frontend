import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';

sealed class GameSearchState {}

class GameSearchInitialState extends GameSearchState {}

class GameSearchLoadingState extends GameSearchState {
  final String? barcode;
  GameSearchLoadingState({this.barcode});
}

class GameSearchScanningState extends GameSearchState {}

class GameSearchCapturingPhotoState extends GameSearchState {
  final String? barcode;
  GameSearchCapturingPhotoState({this.barcode});
}

class GameSearchNoResultState extends GameSearchState {
  final String? barcode;
  GameSearchNoResultState({this.barcode});
}

class GameSearchUploadingPhotoState extends GameSearchState {
  final String? barcode;
  GameSearchUploadingPhotoState({this.barcode});
}

class GameSearchLoadedGamesState extends GameSearchState {
  final List<GameEntity> games;
  final String? barcode;
  GameSearchLoadedGamesState({required this.games, this.barcode});
}

class GameSearchFailureState extends GameSearchState {
  final String errorMessage;
  final String? barcode;
  GameSearchFailureState({required this.errorMessage, this.barcode});
}
