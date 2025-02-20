import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';
import 'package:le_spawn_fr/features/bank/features/games/3_presentation/widget/game-carousel/game-cover.widget.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game.cubit.dart';

class ConfirmGameTab extends StatefulWidget {
  final GameEntity game;
  final VoidCallback onGoBack;

  const ConfirmGameTab({
    super.key,
    required this.game,
    required this.onGoBack,
  });

  @override
  State<ConfirmGameTab> createState() => _ConfirmGameTabState();
}

class _ConfirmGameTabState extends State<ConfirmGameTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        children: [
          Expanded(
            child: _buildOneGameContent(context, widget.game),
          )
        ],
      ),
    );
  }

  Widget _buildOneGameContent(BuildContext context, GameEntity game) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 24),
          GameCoverWidget(game: game, width: 150, height: 200),
          const SizedBox(height: 24),
          Text(game.name, style: Theme.of(context).textTheme.bodySmall),
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
                onPressed: () => BlocProvider.of<AddNewGameCubit>(context).confirmGame(widget.game.id),
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
