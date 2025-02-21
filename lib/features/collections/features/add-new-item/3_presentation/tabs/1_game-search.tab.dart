import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/core/utils/litterals.util.dart';
import 'package:le_spawn_fr/core/widgets/separation/separation.widget.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';
import 'package:le_spawn_fr/features/bank/features/games/3_presentation/widget/game-carousel/game-cover.widget.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game.cubit.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game.state.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/widget/barcode-scanner.widget.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/widget/scan-barcode-button.widget.dart';

class GameSearchTab extends StatefulWidget {
  const GameSearchTab({
    super.key,
  });

  @override
  State<GameSearchTab> createState() => _GameSearchTabState();
}

class _GameSearchTabState extends State<GameSearchTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _showBarcodeDrawer({bool isDebug = false}) {
    if (!mounted) return;

    final cubit = BlocProvider.of<AddNewGameCubit>(context);
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: false,
      builder: (BuildContext modalContext) => BarcodeScannerWidget(
        addNewGameCubit: cubit,
        isDebug: isDebug,
        onGamesFetched: () => Navigator.of(modalContext).pop(),
      ),
    );
  }

  _clearSearch() {
    _searchController.clear();
    context.read<AddNewGameCubit>().resetGame();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          ScanBarcodeButtonWidget(
            text: 'Scanner un code-barre',
            onScanFirstGamePressed: _showBarcodeDrawer,
          ),
          SeparationWidget(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 100),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search your game',
                suffixIcon: GestureDetector(
                  onTap: _clearSearch,
                  child: const Icon(Icons.clear),
                ),
              ),
              onSubmitted: (value) => context.read<AddNewGameCubit>().searchGames(value),
              onChanged: (value) => context.read<AddNewGameCubit>().searchGames(value),
            ),
          ),
          BlocBuilder<AddNewGameCubit, AddNewGameState>(
            builder: (context, state) {
              return Expanded(
                child: Column(
                  children: [
                    switch (state) {
                      AddNewGameLoadedGamesState() => _buildGamesList(state.games),
                      AddNewGameLoadingState() => _buildLoadingSpinner(),
                      _ => const SizedBox.shrink(),
                    },
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingSpinner() => Expanded(child: const Center(child: CircularProgressIndicator()));

  Widget _buildGamesList(List<GameEntity> games) {
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: games.length,
        separatorBuilder: (context, index) => const Divider(height: 32),
        itemBuilder: (context, index) {
          final game = games[index];

          return GameTile(game: game);
        },
      ),
    );
  }
}

class GameTile extends StatelessWidget {
  const GameTile({
    super.key,
    required this.game,
  });

  final GameEntity game;

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
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
        ],
      ),
      trailing: Text(LitteralsUtil.getGameCategory(game.category.name)),
      onTap: () => context.read<AddNewGameCubit>().selectGame(game.id),
    );
  }
}
