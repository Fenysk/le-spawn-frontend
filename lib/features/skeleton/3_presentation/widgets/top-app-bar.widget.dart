import 'package:flutter/material.dart';
import 'package:le_spawn_fr/core/constant/image.constant.dart';
import 'package:le_spawn_fr/core/widgets/version/version.widget.dart';
import 'package:le_spawn_fr/features/skeleton/3_presentation/bloc/tabs_state.dart';

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
      actions: [
        VersionWidget(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
