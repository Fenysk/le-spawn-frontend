import 'package:flutter/material.dart';
import 'package:le_spawn_fr/core/theme/app.theme.dart';
import 'package:le_spawn_fr/features/collections/3_presentation/widget/collection-game-list.widget.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/3_presentation/widget/button-add-new-item.widget.dart';
import 'package:le_spawn_fr/features/collections/3_presentation/widget/collection-list.widget.dart';
import 'package:outlined_text/outlined_text.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    return Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CollectionListWidget(),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: OutlinedText(
                    text: Text(
                      'Ma collection',
                      style: appTheme.textTheme.titleLarge,
                    ),
                    strokes: [
                      OutlinedTextStroke(width: 3, color: AppTheme.primaryText),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                CollectionGameListWidget(),
                const SizedBox(height: 96),
              ],
            ),
          ),
        ),
        ButtonAddNewItemWidget(),
      ],
    );
  }
}
