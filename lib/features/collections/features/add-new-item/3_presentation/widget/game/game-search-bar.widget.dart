import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/game-search/game-search.cubit.dart';

class GameSearchBar extends StatelessWidget {
  const GameSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Rechercher un jeu...',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        context.read<GameSearchCubit>().searchGamesFromQuery(value);
      },
    );
  }
}
