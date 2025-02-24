import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/core/widgets/separation/separation.widget.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game/add-new-game.cubit.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/game-search/game-search.cubit.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/game-search/game-search.state.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/widget/game/game-list.widget.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/widget/game/game-search-bar.widget.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/widget/camera/big-button.widget.dart';

class GameSearchView extends StatelessWidget {
  const GameSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 250,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16,
              children: [
                BigButton(
                  type: ButtonType.primary,
                  icon: FluentIcons.barcode_scanner_24_filled,
                  text: 'Scanner un code-barre',
                  onPressed: () => context.read<GameSearchCubit>().startScanning(),
                ),
                BigButton(
                  icon: FluentIcons.camera_24_filled,
                  text: 'Prendre une photo',
                  onPressed: () => context.read<GameSearchCubit>().startPhotoCapture(),
                ),
              ],
            ),
          ),
          const SeparationWidget(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 150),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: GameSearchBar(),
          ),
          Flexible(
            child: BlocBuilder<GameSearchCubit, GameSearchState>(
              builder: (context, state) {
                return switch (state) {
                  GameSearchLoadedGamesState() => GameList(
                      games: state.games,
                      onGameSelected: (gameId) {
                        debugPrint('🎮 Game selected: $gameId');
                        final game = context.read<GameSearchCubit>().getGameById(gameId);
                        if (game != null) {
                          context.read<AddNewGameCubit>().selectGame(game);
                        } else {
                          debugPrint('❌ Could not find game with ID: $gameId');
                        }
                      },
                    ),
                  GameSearchLoadingState() => const Center(child: CircularProgressIndicator()),
                  _ => const SizedBox.shrink(),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}
