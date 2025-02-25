import 'package:flutter/material.dart';
import 'package:le_spawn_fr/core/theme/app.theme.dart';
import 'package:le_spawn_fr/core/widgets/animated-yellow-bars-background.widget.dart';
import 'package:le_spawn_fr/features/bank/features/games/3_presentation/widget/game-carousel/game-carousel.widget.dart';
import 'package:le_spawn_fr/features/collections/2_domain/entity/collection.entity.dart';

class CollectionCard extends StatelessWidget {
  const CollectionCard({
    super.key,
    required this.collection,
  });

  final CollectionEntity collection;

  @override
  Widget build(BuildContext context) {
    final gamesToShow = collection.gameItems.map((gameItem) => gameItem.game).toList();
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface,
            width: 2,
          ),
          color: AppTheme.accentYellow,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
              offset: const Offset(3, 6),
              blurRadius: 10,
            )
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            const Positioned.fill(
              child: AnimatedYellowBarsBackgroundWidget(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    _buildTitle(context),
                    GameCarouselWidget(
                      games: gamesToShow,
                      debugMode: false,
                      height: 200.0,
                      coverHeight: 170.0,
                      isLastItemOnTop: false,
                      isCenterItemOnTop: false,
                      alignLeft: true,
                      scrollPosition: 0.07874015748031482,
                      perspectiveIntensity: 1.5748031496062982,
                      spacingFactor: 0.11811023622047244,
                      circleRadius: 615.0472440944884,
                      circleOffset: Offset(-170.4803149606305, 622.9212598425197),
                      perspectiveOffset: 0.0,
                      hoverSpacingIncrease: 0.02,
                      coverRatio: 0.7,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Positioned _buildTitle(BuildContext context) {
    return Positioned(
      right: 24,
      top: 0,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: collection.gameItems.length.toString(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.primaryText,
                fontSize: 64,
                shadows: [],
              ),
            ),
            TextSpan(
              text: ' jeux',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppTheme.primaryText,
                fontSize: 32,
                shadows: [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
