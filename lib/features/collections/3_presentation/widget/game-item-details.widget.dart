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
    if (gameItem.game == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: Container(
        color: Colors.white,
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(context),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 32),
                  _buildStateSection(context),
                  const SizedBox(height: 32),
                  _buildInfoSection(context),
                  if (gameItem.game?.summary != null) ...[
                    const SizedBox(height: 32),
                    _buildSummarySection(context),
                  ],
                  if (gameItem.game?.storyline != null) ...[
                    const SizedBox(height: 32),
                    _buildStorylineSection(context),
                  ],
                  const SizedBox(height: 50),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F9FA),
      child: Column(
        children: [
          const SizedBox(height: 32),
          Hero(
            tag: 'game-cover-${gameItem.game!.id}',
            child: GameCoverWidget(
              game: gameItem.game!,
              width: 180,
              height: 240,
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Text(
                  gameItem.game!.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF212529),
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9ECEF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    LitteralsUtil.getGameCategory(gameItem.game!.category.name),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF495057),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildActionButtons(context),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: const Text('Confirmation'),
                content: Text('Voulez-vous vraiment supprimer ${gameItem.game!.name} de votre collection ?'),
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8D7DA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.delete_outline, size: 18, color: Color(0xFFDC3545)),
                const SizedBox(width: 6),
                const Text(
                  'Supprimer',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFDC3545),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (dialogContext) => ReportGameDialog(
                game: gameItem.game!,
                parentContext: context,
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F3F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.report_problem_outlined, size: 18, color: Color(0xFF6C757D)),
                const SizedBox(width: 6),
                const Text(
                  'Signaler',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6C757D),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStateSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.inventory_2, size: 20, color: Color(0xFF6C757D)),
            SizedBox(width: 8),
            Text(
              'État de l\'article',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF212529),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              if (gameItem.hasGame) _buildStateItem(context, 'Jeu', gameItem.stateGame),
              if (gameItem.hasGame && (gameItem.hasBox || gameItem.hasPaper))
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1, color: Color(0xFFE9ECEF)),
                ),
              if (gameItem.hasBox) _buildStateItem(context, 'Boîte', gameItem.stateBox),
              if (gameItem.hasBox && gameItem.hasPaper)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1, color: Color(0xFFE9ECEF)),
                ),
              if (gameItem.hasPaper) _buildStateItem(context, 'Notice', gameItem.statePaper),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStateItem(BuildContext context, String label, String? state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF495057),
          ),
        ),
        Text(
          state ?? 'Non spécifié',
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF6C757D),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.info_outline, size: 20, color: Color(0xFF6C757D)),
            SizedBox(width: 8),
            Text(
              'Informations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF212529),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (gameItem.game!.platforms.isNotEmpty) _buildInfoDetailItem(context, 'Plateformes', gameItem.game!.platforms.map((p) => '${p.name} (${p.abbreviation})').toList(), Icons.devices),
        if (gameItem.game!.genres.isNotEmpty) ...[
          const SizedBox(height: 20),
          _buildInfoDetailItem(context, 'Genres', gameItem.game!.genres.toList(), Icons.category),
        ],
        if (gameItem.game!.franchises.isNotEmpty) ...[
          const SizedBox(height: 20),
          _buildInfoDetailItem(context, 'Franchises', gameItem.game!.franchises.toList(), Icons.extension),
        ],
        if (gameItem.game!.firstReleaseDate != null) ...[
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.calendar_today, size: 20, color: Color(0xFF6C757D)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Date de sortie',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF495057),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    gameItem.game!.firstReleaseDate!.toString().split(' ')[0],
                    style: const TextStyle(
                      fontSize: 15,
                      color: Color(0xFF6C757D),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
        if (gameItem.game!.gameLocalizations.isNotEmpty) ...[
          const SizedBox(height: 20),
          const Row(
            children: [
              Icon(Icons.language, size: 20, color: Color(0xFF6C757D)),
              SizedBox(width: 12),
              Text(
                'Régions',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF495057),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...gameItem.game!.gameLocalizations.map((loc) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE9ECEF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          loc.region.abbreviation,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF495057),
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
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF495057),
                              ),
                            ),
                            if (loc.name != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                loc.name!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF6C757D),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ],
    );
  }

  Widget _buildInfoDetailItem(BuildContext context, String title, List<String> items, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF6C757D)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF495057),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: items
                    .map((item) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6C757D),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummarySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.description, size: 20, color: Color(0xFF6C757D)),
            SizedBox(width: 8),
            Text(
              'Résumé',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF212529),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          gameItem.game!.summary!,
          style: const TextStyle(
            fontSize: 15,
            height: 1.5,
            color: Color(0xFF495057),
          ),
        ),
      ],
    );
  }

  Widget _buildStorylineSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.auto_stories, size: 20, color: Color(0xFF6C757D)),
            SizedBox(width: 8),
            Text(
              'Histoire',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF212529),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          gameItem.game!.storyline!,
          style: const TextStyle(
            fontSize: 15,
            height: 1.5,
            color: Color(0xFF495057),
          ),
        ),
      ],
    );
  }
}
