import 'package:flutter/material.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';

class GameList extends StatelessWidget {
  final List<GameEntity> games;
  final Function(String gameId)? onGameSelected;

  const GameList({
    super.key,
    required this.games,
    this.onGameSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        return ListTile(
          leading: game.coverUrl != null
              ? Image.network(
                  game.coverUrl!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
              : const Icon(Icons.gamepad),
          title: Text(game.name),
          subtitle: game.platforms.isNotEmpty ? Text(game.platforms.map((platform) => platform.name).join(', ')) : null,
          onTap: () => onGameSelected?.call(game.id),
        );
      },
    );
  }
}
