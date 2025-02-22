import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/core/utils/litterals.util.dart';
import 'package:le_spawn_fr/core/widgets/separation/separation.widget.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';
import 'package:le_spawn_fr/features/bank/features/games/3_presentation/widget/game-carousel/game-cover.widget.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game.cubit.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game.state.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/widget/barcode-scanner.widget.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/widget/game-cover-capture.widget.dart';
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

  _clearSearch() {
    _searchController.clear();
    context.read<AddNewGameCubit>().resetGame();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddNewGameCubit, AddNewGameState>(
      listener: (context, state) {
        debugPrint('🎮 Current state: ${state.runtimeType}');
      },
      builder: (context, state) {
        return switch (state) {
          AddNewGameScanningState() => _buildScannerView(),
          AddNewGameCapturingPhotoState() => _buildCaptureView(state.barcode!),
          AddNewGameNoResultState() => _buildNoResultView(context, state.barcode!),
          _ => _buildSearchView(),
        };
      },
    );
  }

  Widget _buildSearchView() {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          ScanBarcodeButtonWidget(
            text: 'Scanner un code-barre',
            onScanFirstGamePressed: () => context.read<AddNewGameCubit>().startScanning(),
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

  Widget _buildScannerView() {
    return BarcodeScannerWidget(
      addNewGameCubit: context.read<AddNewGameCubit>(),
      onGamesFetched: () {},
      onClose: () {},
    );
  }

  Widget _buildCaptureView(String barcode) {
    return GameCoverCaptureWidget(
      barcode: barcode,
    );
  }

  Widget _buildLoadingSpinner() => const Center(child: CircularProgressIndicator());

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

  Widget _buildNoResultView(BuildContext context, String barcode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48,
          ),
          const SizedBox(height: 16),
          const Text('Jeu non trouvé'),
          const SizedBox(height: 8),
          const Text('Voulez-vous prendre une photo de la couverture ?'),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => context.read<AddNewGameCubit>().resetGame(),
                child: const Text('Annuler'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () => context.read<AddNewGameCubit>().startPhotoCapture(barcode),
                child: const Text('Prendre une photo'),
              ),
            ],
          ),
        ],
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
