import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/core/widgets/separation/separation.widget.dart';
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        _buildGamesList(),
      ],
    );
  }

  _clearSearch() {
    _searchController.clear();
    context.read<AddNewGameCubit>().resetGame();
  }

  _buildGamesList() {
    return Expanded(
      child: BlocBuilder<AddNewGameCubit, AddNewGameState>(
        builder: (context, state) {
          if (state is AddNewGameLoadedGamesState) {
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: state.games.length,
              separatorBuilder: (context, index) => const Divider(height: 32),
              itemBuilder: (context, index) {
                final game = state.games[index];
                return ListTile(
                  leading: GameCoverWidget(
                    game: game,
                    height: 60,
                    borderRadius: 4,
                  ),
                  title: Text(game.name),
                  onTap: () => context.read<AddNewGameCubit>().selectGame(game.id),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
