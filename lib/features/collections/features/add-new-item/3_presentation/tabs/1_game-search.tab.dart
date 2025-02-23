import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game/add-new-game.cubit.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/game-search/game-search.cubit.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/game-search/game-search.state.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/widget/camera/barcode-scanner.widget.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/widget/camera/game-cover-capture.widget.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/widget/game/game-no-result-view.widget.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/widget/game/game-search-view.widget.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/widget/game/game-uploading-photo-view.widget.dart';

class GameSearchTab extends StatelessWidget {
  const GameSearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameSearchCubit(),
      child: BlocConsumer<GameSearchCubit, GameSearchState>(
        listener: (context, state) {
          debugPrint('🎮 Current state: ${state.runtimeType}');
          if (state is GameSearchLoadedGamesState && state.games.length == 1) {
            context.read<AddNewGameCubit>().selectGame(state.games.first.id);
          }
        },
        builder: (context, state) {
          return switch (state) {
            GameSearchScanningState() => BarcodeScannerWidget(
                onClose: () => context.read<GameSearchCubit>().reset(),
              ),
            GameSearchCapturingPhotoState() => GameCoverCaptureWidget(
                barcode: state.barcode,
              ),
            GameSearchNoResultState() => GameNoResultView(barcode: state.barcode),
            GameSearchUploadingPhotoState() => const GameUploadingPhotoView(),
            _ => const GameSearchView(),
          };
        },
      ),
    );
  }
}
