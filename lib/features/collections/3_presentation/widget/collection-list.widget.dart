import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:le_spawn_fr/features/collections/2_domain/entity/collection.entity.dart';
import 'package:le_spawn_fr/features/collections/3_presentation/bloc/collections.cubit.dart';
import 'package:le_spawn_fr/features/collections/3_presentation/widget/collection-card.widget.dart';

class CollectionListWidget extends StatelessWidget {
  const CollectionListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionsCubit, CollectionsState>(
      builder: (context, state) => switch (state) {
        CollectionsSuccessState() => _buildLoadedContent(state.collections),
        CollectionsLoadingState() => _buildLoadingContent(),
        CollectionsFailureState() => _buildEmptyContent(),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Widget _buildLoadedContent(List<CollectionEntity> collections) {
    return CollectionCard(collection: collections[0]);
  }

  Widget _buildLoadingContent() {
    return const SizedBox(
      height: 200,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildEmptyContent() {
    return CollectionCard(
      collection: CollectionEntity.empty(),
    );
  }
}
