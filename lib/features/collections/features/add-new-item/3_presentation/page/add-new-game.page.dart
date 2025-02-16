import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game.cubit.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game.state.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/tabs/1_game-detection.tab.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/tabs/2_confirm-game.tab.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/tabs/3_new-item-form.tab.dart';

class AddNewGamePage extends StatefulWidget {
  const AddNewGamePage({super.key});

  @override
  State<AddNewGamePage> createState() => _AddNewGamePageState();
}

class _AddNewGamePageState extends State<AddNewGamePage> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => AddNewGameCubit(),
        child: BlocBuilder<AddNewGameCubit, AddNewGameState>(
            builder: (context, state) => switch (state) {
                  AddNewGameInitialState() => buildInitialContent(),
                  AddNewGameFailureState() => buildFailureContent(context, state.errorMessage),
                  AddNewGameLoadingState() => _buildLoadingContent(),
                  AddNewGameLoadedGamesState() => ConfirmGameTab(
                      games: state.games,
                      onGoBack: () => BlocProvider.of<AddNewGameCubit>(context).resetGame(),
                    ),
                  AddNewGameItemInfoState() => NewItemFormTab(game: state.game),
                  _ => const SizedBox.shrink(),
                }),
      ),
    );
  }

  Widget buildFailureContent(BuildContext context, String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(errorMessage),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => BlocProvider.of<AddNewGameCubit>(context).resetGame(),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget buildInitialContent() {
    if (!mounted) return const SizedBox.shrink();
    return const GameDetectionTab();
  }

  Widget _buildLoadingContent() {
    if (!mounted) return const SizedBox.shrink();
    return const Center(child: CircularProgressIndicator());
  }
}
