import 'package:flutter/material.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';

class AddNewGameFormTab extends StatelessWidget {
  final GameEntity? game;
  final VoidCallback onGoBack;

  const AddNewGameFormTab({
    super.key,
    required this.game,
    required this.onGoBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Game: ${game?.name ?? 'No game'}'),
        ElevatedButton(
          onPressed: onGoBack,
          child: const Text('Go Back'),
        ),
      ],
    );
  }
}
