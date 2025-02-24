import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/core/utils/litterals.util.dart';
import 'package:le_spawn_fr/features/bank/features/games/3_presentation/widget/game-carousel/game-cover.widget.dart';
import 'package:le_spawn_fr/features/collections/2_domain/entity/game-item.entity.dart';
import 'package:le_spawn_fr/features/collections/3_presentation/bloc/collections.cubit.dart';
import 'package:le_spawn_fr/features/reports/3_presentation/widget/report-game-dialog.widget.dart';

class GameItemDetailsWidget extends StatelessWidget {
  final GameItemEntity gameItem;
  final ScrollController scrollController;

  const GameItemDetailsWidget({
    super.key,
    required this.gameItem,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildStateCard(context),
                    const SizedBox(height: 16),
                    _buildInfoCard(context),
                    if (gameItem.game.summary != null || gameItem.game.storyline != null) const SizedBox(height: 16),
                    if (gameItem.game.summary != null) _buildDescriptionCard(context, 'Résumé', gameItem.game.summary!, Icons.description),
                    if (gameItem.game.storyline != null) ...[
                      const SizedBox(height: 16),
                      _buildDescriptionCard(context, 'Histoire', gameItem.game.storyline!, Icons.auto_stories),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.surface,
          ],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Hero(
            tag: 'game-cover-${gameItem.game.id}',
            child: GameCoverWidget(
              game: gameItem.game,
              width: 200,
              height: 266,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Text(
                  gameItem.game.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    LitteralsUtil.getGameCategory(gameItem.game.category.name),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildDeleteButton(context),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.inventory_2, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'État de l\'article',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStateItem(context, 'Jeu', gameItem.hasGame, gameItem.stateGame),
            if (gameItem.hasGame) const SizedBox(height: 8),
            _buildStateItem(context, 'Boîte', gameItem.hasBox, gameItem.stateBox),
            if (gameItem.hasBox) const SizedBox(height: 8),
            _buildStateItem(context, 'Notice', gameItem.hasPaper, gameItem.statePaper),
          ],
        ),
      ),
    );
  }

  Widget _buildStateItem(BuildContext context, String label, bool hasItem, String? state) {
    if (!hasItem) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            '$label:',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(width: 8),
          Text(
            state ?? 'Non spécifié',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Informations',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (gameItem.game.platforms.isNotEmpty) _buildInfoSection(context, 'Plateformes', gameItem.game.platforms.map((p) => '${p.name} (${p.abbreviation})').toList(), Icons.devices),
            if (gameItem.game.genres.isNotEmpty) ...[
              if (gameItem.game.platforms.isNotEmpty) const SizedBox(height: 16),
              _buildInfoSection(context, 'Genres', gameItem.game.genres.toList(), Icons.category),
            ],
            if (gameItem.game.franchises.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildInfoSection(context, 'Franchises', gameItem.game.franchises.toList(), Icons.extension),
            ],
            if (gameItem.game.firstReleaseDate != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 20, color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(width: 8),
                  Text(
                    'Date de sortie: ${gameItem.game.firstReleaseDate!.toString().split(' ')[0]}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
            if (gameItem.game.gameLocalizations.isNotEmpty) ...[
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.language, size: 20, color: Theme.of(context).colorScheme.secondary),
                      const SizedBox(width: 8),
                      Text(
                        'Régions',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...gameItem.game.gameLocalizations.map((loc) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.outlineVariant,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.secondaryContainer,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    loc.region.abbreviation,
                                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                          color: Theme.of(context).colorScheme.onSecondaryContainer,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        loc.region.name,
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                      if (loc.name != null) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          loc.name!,
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                              ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, List<String> items, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).colorScheme.secondary),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items
              .map((item) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      item,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildDescriptionCard(BuildContext context, String title, String content, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FilledButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: const Text('Confirmation'),
                content: Text('Voulez-vous vraiment supprimer ${gameItem.game.name} de votre collection ?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Annuler'),
                  ),
                  FilledButton(
                    onPressed: () {
                      BlocProvider.of<CollectionsCubit>(context).deleteGameItem(gameItem);
                      Navigator.pop(dialogContext);
                      Navigator.pop(context);
                    },
                    child: const Text('Supprimer'),
                  ),
                ],
              ),
            );
          },
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
          ),
          icon: const Icon(Icons.delete_outline),
          label: const Text('Supprimer'),
        ),
        const SizedBox(width: 16),
        TextButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (dialogContext) => ReportGameDialog(
                game: gameItem.game,
                parentContext: context,
              ),
            );
          },
          icon: const Icon(Icons.report_problem_outlined),
          label: const Text('Signaler un problème'),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
        ),
      ],
    );
  }
}
