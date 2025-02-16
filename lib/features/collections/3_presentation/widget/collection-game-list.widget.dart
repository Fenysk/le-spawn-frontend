import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/features/bank/features/games/3_presentation/widget/game-carousel/game-cover.widget.dart';
import 'package:le_spawn_fr/features/collections/2_domain/entity/collection.entity.dart';
import 'package:le_spawn_fr/features/collections/3_presentation/bloc/collections.cubit.dart';
import 'package:le_spawn_fr/features/collections/3_presentation/widget/collection-card.widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CollectionGameListWidget extends StatefulWidget {
  const CollectionGameListWidget({super.key});

  @override
  State<CollectionGameListWidget> createState() => _CollectionGameListWidgetState();
}

class _CollectionGameListWidgetState extends State<CollectionGameListWidget> {
  String? hoverItem;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionsCubit, CollectionsState>(
      builder: (context, state) => switch (state) {
        CollectionsSuccessState() => _buildLoadedContent(state.collections),
        CollectionsLoadingState() => _buildLoadingContent(),
        CollectionsFailureState() => _buildFailureContent(state.errorMessage),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Widget _buildLoadedContent(List<CollectionEntity> collections) {
    final collection = collections[0];
    return Center(
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.start,
        children: [
          for (final item in collection.gameItems)
            MouseRegion(
              onEnter: (_) => setState(() => hoverItem = item.id),
              onExit: (_) => setState(() => hoverItem = null),
              child: GestureDetector(
                onTapDown: (_) => setState(() => hoverItem = item.id),
                onTapUp: (_) => setState(() => hoverItem = null),
                onTapCancel: () => setState(() => hoverItem = null),
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 150),
                  tween: Tween<double>(
                    begin: 0,
                    end: hoverItem == item.id ? 0.2 : 0,
                  ),
                  builder: (context, intensity, child) {
                    return GameCoverWidget(
                      game: item.game,
                      height: 150,
                      width: 100,
                      intensity: intensity,
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingContent() {
    return Skeletonizer(
      enabled: true,
      child: Skeleton.leaf(
        child: CollectionCard(
          collection: CollectionEntity.empty(),
        ),
      ),
    );
  }

  Widget _buildFailureContent(String message) {
    return CollectionCard(collection: CollectionEntity.empty());
  }
}
