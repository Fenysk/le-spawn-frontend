import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/core/utils/litterals.util.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';
import 'package:le_spawn_fr/features/bank/features/games/3_presentation/widget/game-carousel/game-cover.widget.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/bloc/add-new-game.cubit.dart';
import 'package:le_spawn_fr/features/reports/3_presentation/widget/report-game-dialog.widget.dart';

class ConfirmGameTab extends StatefulWidget {
  final GameEntity game;
  final VoidCallback onGoBack;

  const ConfirmGameTab({
    super.key,
    required this.game,
    required this.onGoBack,
  });

  @override
  State<ConfirmGameTab> createState() => _ConfirmGameTabState();
}

class _ConfirmGameTabState extends State<ConfirmGameTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        children: [
          Expanded(
            child: _buildOneGameDetailsSection(context, widget.game),
          ),
          _buildConfirmationSection(context),
        ],
      ),
    );
  }

  Container _buildConfirmationSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1.0,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Text('Est-ce le bon jeu ?', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: widget.onGoBack,
                child: const Text('Non, réessayer'),
              ),
              const SizedBox(width: 24),
              ElevatedButton(
                onPressed: () => BlocProvider.of<AddNewGameCubit>(context).confirmGame(widget.game.id),
                child: const Text('Oui, c\'est bon'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => ReportGameDialog(game: widget.game),
              );
            },
            icon: const Icon(Icons.report_problem_outlined),
            label: const Text('Signaler un problème'),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOneGameDetailsSection(BuildContext context, GameEntity game) {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Center(child: GameCoverWidget(game: game, width: 150, height: 200)),
              const SizedBox(height: 24),
              Text(game.name, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              Text('Catégorie: ${LitteralsUtil.getGameCategory(game.category.name)}', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 24),
              if (game.platforms.isNotEmpty) ..._buildDetailSection('Plateformes:', game.platforms.map((p) => '${p.name} (${p.abbreviation})')),
              if (game.genres.isNotEmpty) ..._buildDetailSection('Genres:', game.genres),
              if (game.franchises.isNotEmpty) ..._buildDetailSection('Franchises:', game.franchises),
              if (game.firstReleaseDate != null) ...[
                Text('Date de sortie:', style: Theme.of(context).textTheme.titleMedium),
                Text(game.firstReleaseDate!.toString().split(' ')[0]),
                const SizedBox(height: 16),
              ],
              if (game.summary != null) ..._buildTextSection('Résumé:', game.summary!),
              if (game.storyline != null) ..._buildTextSection('Histoire:', game.storyline!),
              if (game.screenshotsUrl.isNotEmpty) ...[
                Text('Captures d\'écran:', style: Theme.of(context).textTheme.titleMedium),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: game.screenshotsUrl.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
                      child: Image.network(
                        game.screenshotsUrl[index],
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDetailSection(String title, Iterable<String> items) {
    return [
      Text(title, style: Theme.of(context).textTheme.titleMedium),
      Wrap(
        spacing: 8,
        children: items.map((item) => Chip(label: Text(item))).toList(),
      ),
      const SizedBox(height: 16),
    ];
  }

  List<Widget> _buildTextSection(String title, String content) {
    return [
      Text(title, style: Theme.of(context).textTheme.titleMedium),
      Text(content, textAlign: TextAlign.justify),
      const SizedBox(height: 16),
    ];
  }
}
