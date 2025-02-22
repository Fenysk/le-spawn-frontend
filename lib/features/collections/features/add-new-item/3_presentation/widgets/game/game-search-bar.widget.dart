import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game.cubit.dart';

class GameSearchBar extends StatefulWidget {
  const GameSearchBar({super.key});

  @override
  State<GameSearchBar> createState() => _GameSearchBarState();
}

class _GameSearchBarState extends State<GameSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  void _clearSearch() {
    _searchController.clear();
    context.read<AddNewGameCubit>().resetGame();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search your game',
        suffixIcon: GestureDetector(
          onTap: _clearSearch,
          child: const Icon(Icons.clear),
        ),
      ),
      onSubmitted: (value) => context.read<AddNewGameCubit>().searchGamesFromQuery(value),
      onChanged: (value) => context.read<AddNewGameCubit>().searchGamesFromQuery(value),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
