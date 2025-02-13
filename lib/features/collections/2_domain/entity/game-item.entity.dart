class GameCollectionItemEntity {
  final String id;
  final bool hasBox;
  final bool hasGame;
  final bool hasPaper;
  final String? stateBox;
  final String? stateGame;
  final String? statePaper;
  final String gameId;
  final String collectionId;

  GameCollectionItemEntity({
    required this.id,
    required this.hasBox,
    required this.hasGame,
    required this.hasPaper,
    this.stateBox,
    this.stateGame,
    this.statePaper,
    required this.gameId,
    required this.collectionId,
  });
}