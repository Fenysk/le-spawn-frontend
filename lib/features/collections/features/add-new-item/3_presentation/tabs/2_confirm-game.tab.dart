import 'package:flutter/material.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';
import 'package:le_spawn_fr/features/bank/features/games/3_presentation/widget/game-carousel/game-cover.widget.dart';

class ConfirmGameTab extends StatefulWidget {
  final GameEntity game;
  final VoidCallback onGoBack;
  final VoidCallback onConfirm;

  const ConfirmGameTab({
    super.key,
    required this.game,
    required this.onGoBack,
    required this.onConfirm,
  });

  @override
  State<ConfirmGameTab> createState() => _ConfirmGameTabState();
}

class _ConfirmGameTabState extends State<ConfirmGameTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 24),
          GameCoverWidget(game: widget.game, width: 150, height: 200),
          const SizedBox(height: 24),
          Text(widget.game.name, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 24),
          Text('Est-ce le bon jeu ?', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: widget.onGoBack,
                child: const Text('Non, réessayer'),
              ),
              const SizedBox(width: 24),
              ElevatedButton(
                onPressed: widget.onConfirm,
                child: const Text('Oui, c\'est bon'),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
