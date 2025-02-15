import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:le_spawn_fr/core/configs/app-routes.config.dart';
import 'package:le_spawn_fr/core/theme/app.theme.dart';

class ButtonAddNewItemWidget extends StatelessWidget {
  const ButtonAddNewItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    void onPressed() => context.goNamed('${AppRoutesConfig.collections}/${AppRoutesConfig.addNewGamePath}');

    return Positioned(
      bottom: 20,
      right: 20,
      child: FloatingActionButton.extended(
        backgroundColor: AppTheme.accentYellow,
        onPressed: onPressed,
        tooltip: 'Add new item',
        icon: const Icon(Icons.add, color: AppTheme.primaryText),
        label: const Text('Add new item', style: TextStyle(color: AppTheme.primaryText)),
      ),
    );
  }
}
