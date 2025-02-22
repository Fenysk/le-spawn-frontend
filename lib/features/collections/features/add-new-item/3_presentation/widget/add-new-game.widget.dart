import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game.cubit.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game.state.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/widget/barcode-scanner.widget.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/widget/game-cover-capture.widget.dart';

class AddNewGameWidget extends StatelessWidget {
  const AddNewGameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNewGameCubit, AddNewGameState>(
      builder: (context, state) {
        return switch (state) {
          AddNewGameInitialState() => _buildInitialView(context),
          AddNewGameScanningState() => _buildScannerView(context),
          AddNewGameCapturingPhotoState() => _buildCaptureView(context, state.barcode!),
          AddNewGameNoResultState() => _buildNoResultView(context, state.barcode!),
          AddNewGameLoadedGamesState() => _buildGamesListView(context, state),
          AddNewGameFailureState() => _buildErrorView(context, state.errorMessage),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }

  Widget _buildInitialView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => context.read<AddNewGameCubit>().startScanning(),
            child: const Text('Scanner un code-barre'),
          ),
          const SizedBox(height: 16),
          const Text('ou'),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Rechercher un jeu',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerView(BuildContext context) {
    return BarcodeScannerWidget(
      addNewGameCubit: context.read<AddNewGameCubit>(),
      onGamesFetched: () {},
      onClose: () => context.read<AddNewGameCubit>().resetGame(),
    );
  }

  Widget _buildCaptureView(BuildContext context, String barcode) {
    return GameCoverCaptureWidget(
      barcode: barcode,
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

  Widget _buildGamesListView(BuildContext context, AddNewGameLoadedGamesState state) {
    return ListView.builder(
      itemCount: state.games.length,
      itemBuilder: (context, index) {
        final game = state.games[index];
        return ListTile(
          title: Text(game.name),
          onTap: () => context.read<AddNewGameCubit>().selectGame(game.id),
        );
      },
    );
  }

  Widget _buildErrorView(BuildContext context, String errorMessage) {
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
          Text(errorMessage),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<AddNewGameCubit>().resetGame(),
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }
}
