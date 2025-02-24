import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:le_spawn_fr/core/configs/app-routes.config.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';
import 'package:le_spawn_fr/features/bank/features/games/3_presentation/widget/game-carousel/game-cover.widget.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game/add-new-game.cubit.dart';

class SuccessTab extends StatefulWidget {
  final GameEntity game;

  const SuccessTab({
    super.key,
    required this.game,
  });

  @override
  State<SuccessTab> createState() => _SuccessTabState();
}

class _SuccessTabState extends State<SuccessTab> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            context.goNamed(
              AppRoutesConfig.collections,
              queryParameters: {
                'shouldRefresh': 'true'
              },
            );
          }
        });
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              GameCoverWidget(
                game: widget.game,
                width: 120,
                height: 160,
                borderRadius: 8,
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Jeu ajouté avec succès !',
          ),
          const SizedBox(height: 8),
          Text(
            widget.game.name,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: BlocProvider.of<AddNewGameCubit>(context).resetGame,
            child: const Text('Ajouter un autre jeu'),
          ),
        ],
      ),
    );
  }
}
