import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/core/utils/litterals.util.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';
import 'package:le_spawn_fr/features/bank/features/games/3_presentation/widget/game-carousel/game-cover.widget.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game.cubit.dart';

class GameList extends StatelessWidget {
  final List<GameEntity> games;

  const GameList({
    super.key,
    required this.games,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: games.length,
      separatorBuilder: (context, index) => const Divider(height: 32),
      itemBuilder: (context, index) {
        final game = games[index];
        return _GameTile(game: game);
      },
    );
  }
}

class _GameTile extends StatelessWidget {
  final GameEntity game;

  const _GameTile({
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: GameCoverWidget(
        game: game,
        height: 60,
        borderRadius: 4,
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(game.name),
          if (game.platforms.isNotEmpty)
            Text(
              game.platforms.map((platform) => platform.name).join(', '),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
        ],
      ),
      trailing: Text(LitteralsUtil.getGameCategory(game.category.name)),
      onTap: () => context.read<AddNewGameCubit>().selectGame(game.id),
    );
  }
}
