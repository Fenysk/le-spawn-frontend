import 'package:flutter/material.dart';
import 'package:le_spawn_frontend/core/constant/image.constant.dart';
import 'package:le_spawn_frontend/features/skeleton/3_presentation/bloc/tabs_state.dart';
import 'package:le_spawn_frontend/features/skeleton/3_presentation/widgets/navbar-button.widget.dart';

class TopAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final TabsState tabsState;

  const TopAppBarWidget({
    super.key,
    required this.tabsState,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 16, top: 4, right: 16),
        child: Image.asset(ImageConstant.logoTextTransparentPath),
      ),
      leadingWidth: 150,
      backgroundColor: Theme.of(context).colorScheme.primary,
      primary: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
