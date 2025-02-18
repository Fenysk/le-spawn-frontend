import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';
import 'package:le_spawn_fr/features/bank/features/games/3_presentation/widget/game-carousel/game-cover.widget.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game.cubit.dart';

class ConfirmGameTab extends StatefulWidget {
  final List<GameEntity> games;
  final VoidCallback onGoBack;

  const ConfirmGameTab({
    super.key,
    required this.games,
    required this.onGoBack,
  });

  @override
  State<ConfirmGameTab> createState() => _ConfirmGameTabState();
}

class _ConfirmGameTabState extends State<ConfirmGameTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        children: [
          _buildSearchGameSection(),
          Expanded(
            child: widget.games.length == 1 ? _buildOneGameContent(context, widget.games.first) : _buildManyGamesContent(),
          )
        ],
      ),
    );
  }

  _buildSearchGameSection() {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'Search your game',
          ),
          onSubmitted: (value) => context.read<AddNewGameCubit>().searchGames(value),
        ),
      ],
    );
  }

  SingleChildScrollView _buildOneGameContent(BuildContext context, GameEntity game) {
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
                onPressed: () => BlocProvider.of<AddNewGameCubit>(context).confirmGame(widget.games.first.id),
                child: const Text('Oui, c\'est bon'),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildManyGamesContent() {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(
            child: Text(
              'Sélectionnez le jeu correct',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final game = widget.games[index];
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => BlocProvider.of<AddNewGameCubit>(context).confirmGame(game.id),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        children: [
                          Expanded(
                            child: GameCoverWidget(
                              game: game,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  game.name,
                                  style: Theme.of(context).textTheme.titleSmall,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  game.platforms.map((platform) => platform.name).toList().join(', '),
                                  style: Theme.of(context).textTheme.bodySmall,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: widget.games.length,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(
            child: ElevatedButton(
              onPressed: widget.onGoBack,
              child: const Text('Aucun jeu ne correspond'),
            ),
          ),
        ),
      ],
    );
  }
}
