import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_frontend/features/collections/2_domain/entity/collection.entity.dart';
import 'package:le_spawn_frontend/features/collections/3_presentation/bloc/collections.cubit.dart';
import 'package:le_spawn_frontend/features/collections/3_presentation/widget/collection-card.widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CollectionListWidget extends StatelessWidget {
  const CollectionListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CollectionsCubit()..loadCollections(),
      child: BlocBuilder<CollectionsCubit, CollectionsState>(
        builder: (context, state) => switch (state) {
          CollectionsSuccessState() => _buildLoadedContent(state.collections),
          CollectionsLoadingState() => _buildLoadingContent(),
          CollectionsFailureState() => _buildFailureContent(state.errorMessage),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }

  Widget _buildLoadedContent(List<CollectionEntity> collections) {
    return CollectionCard(collection: collections[0]);
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
