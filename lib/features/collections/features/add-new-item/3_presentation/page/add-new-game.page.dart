import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:le_spawn_fr/core/configs/app-routes.config.dart';
import 'package:le_spawn_fr/features/collections/3_presentation/bloc/collections.cubit.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game/add-new-game.cubit.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game/add-new-game.state.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/tabs/1_game-search.tab.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/tabs/2_confirm-game.tab.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/tabs/3_new-item-form.tab.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/tabs/4_success.tab.dart';

class AddNewGamePage extends StatefulWidget {
  const AddNewGamePage({super.key});

  @override
  State<AddNewGamePage> createState() => _AddNewGamePageState();
}

class _AddNewGamePageState extends State<AddNewGamePage> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.read<AddNewGameCubit>().state is AddNewGameSuccessState) {
              context.read<CollectionsCubit>().loadCollections();
            }

            context.goNamed(AppRoutesConfig.collections, queryParameters: {
              'shouldRefresh': 'true'
            });
          },
        ),
      ),
      body: BlocBuilder<AddNewGameCubit, AddNewGameState>(
        builder: (context, state) => switch (state) {
          AddNewGameInitialState() => const GameSearchTab(),
          AddNewGameItemInfoState() => NewItemFormTab(game: state.game),
          AddNewGameConfirmationGameState() => ConfirmGameTab(
              game: state.game,
              onGoBack: () => context.read<AddNewGameCubit>().resetGame(),
            ),
          AddNewGameSuccessState() => SuccessTab(game: state.game),
          _ => const GameSearchTab(),
        },
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
}
