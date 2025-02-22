import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/core/widgets/separation/separation.widget.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game.cubit.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game.state.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/widgets/camera/barcode-scanner.widget.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/widgets/camera/game-cover-capture.widget.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/widgets/game/game-list.widget.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/widgets/game/game-search-bar.widget.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/widgets/big-button.widget.dart';

class GameSearchTab extends StatelessWidget {
  const GameSearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddNewGameCubit, AddNewGameState>(
      listener: (context, state) {
        debugPrint('🎮 Current state: ${state.runtimeType}');
      },
      builder: (context, state) {
        return switch (state) {
          AddNewGameScanningState() => BarcodeScannerWidget(
              onClose: () => context.read<AddNewGameCubit>().resetGame(),
            ),
          AddNewGameCapturingPhotoState() => GameCoverCaptureWidget(
              barcode: state.barcode,
            ),
          AddNewGameNoResultState() => _buildNoResultView(context, state.barcode!),
          AddNewGameUploadingPhotoState() => _buildUploadingPhotoView(context),
          _ => _buildSearchView(context),
        };
      },
    );
  }

  Widget _buildSearchView(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          Column(
            spacing: 16,
            children: [
              BigButton(
                icon: Icons.qr_code_scanner,
                text: 'Scanner un code-barre',
                onPressed: () => context.read<AddNewGameCubit>().startScanning(),
              ),
              BigButton(
                icon: Icons.photo,
                text: 'Prendre une photo',
                onPressed: () => context.read<AddNewGameCubit>().startPhotoCapture(),
              ),
            ],
          ),
          const SeparationWidget(
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 100),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: GameSearchBar(),
          ),
          Expanded(
            child: BlocBuilder<AddNewGameCubit, AddNewGameState>(
              builder: (context, state) {
                return switch (state) {
                  AddNewGameLoadedGamesState() => GameList(games: state.games),
                  AddNewGameLoadingState() => const Center(child: CircularProgressIndicator()),
                  _ => const SizedBox.shrink(),
                };
              },
            ),
          ),
        ],
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
                onPressed: () => context.read<AddNewGameCubit>().startPhotoCapture(barcode: barcode),
                child: const Text('Prendre une photo'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadingPhotoView(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Analyzing photo...'),
        ],
      ),
    );
  }
}
