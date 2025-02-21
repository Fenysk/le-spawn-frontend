class CreateGameReportDto {
  final String gameId;
  final String explication;

  CreateGameReportDto({
    required this.gameId,
    required this.explication,
  });

  Map<String, dynamic> toJson() {
    return {
      'gameId': gameId,
      'explication': explication,
    };
  }
}
