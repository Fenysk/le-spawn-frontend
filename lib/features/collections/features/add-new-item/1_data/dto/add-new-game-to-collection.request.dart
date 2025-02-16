import 'dart:convert';

class AddGameItemToCollectionRequest {
  final String collectionId;
  final String gameId;
  final bool hasBox;
  final bool hasGame;
  final bool hasPaper;
  final String? stateBox;
  final String? stateGame;
  final String? statePaper;

  const AddGameItemToCollectionRequest({
    required this.collectionId,
    required this.gameId,
    required this.hasBox,
    required this.hasGame,
    required this.hasPaper,
    this.stateBox,
    this.stateGame,
    this.statePaper,
  });

  String toJson() => jsonEncode({
        'collectionId': collectionId,
        'gameId': gameId,
        'hasBox': hasBox,
        'hasGame': hasGame,
        'hasPaper': hasPaper,
        'stateBox': stateBox,
        'stateGame': stateGame,
        'statePaper': statePaper,
      });
}
