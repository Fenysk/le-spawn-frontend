import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-game/3_presentation/bloc/add-new-game.cubit.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-game/3_presentation/tabs/1_game-detection.tab.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-game/3_presentation/tabs/2_add-new-game-form.tab.dart';

class AddNewGamePage extends StatefulWidget {
  const AddNewGamePage({super.key});

  @override
  State<AddNewGamePage> createState() => _AddNewGamePageState();
}

class _AddNewGamePageState extends State<AddNewGamePage> with SingleTickerProviderStateMixin {
  GameEntity? game;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void onGameFetched(GameEntity game) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Permet d'executer ce code apres le build
      setState(() {
        this.game = game;
        _tabController.animateTo(1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: [
          BlocProvider(
            create: (context) => AddNewGameCubit(),
            child: GameDetectionTab(
              onGameFetched: onGameFetched,
              skipStep: () => _tabController.animateTo(1),
            ),
          ),
          AddNewGameFormTab(
            game: game,
            onGoBack: () => _tabController.animateTo(0),
          ),
        ],
      ),
    );
  }
}
