import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:le_spawn_fr/core/theme/app.theme.dart';
import 'package:le_spawn_fr/features/skeleton/3_presentation/bloc/tabs_cubit.dart';

IconData getIconData({required TabType type, required bool isFilled}) => switch (type) {
      TabType.collections => isFilled ? Icons.gamepad_rounded : Icons.games_outlined,
      TabType.bank => isFilled ? FluentIcons.compass_northwest_28_filled : FluentIcons.compass_northwest_28_regular,
      TabType.profile => isFilled ? FluentIcons.person_32_filled : FluentIcons.person_32_regular,
    };

String getLabelData({required TabType type}) => switch (type) {
      TabType.collections => 'Ma collection',
      TabType.bank => 'Explorer',
      TabType.profile => 'Profile',
    };

class NavbarButtonWidget extends StatelessWidget {
  final TabType type;
  final bool isActive;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const NavbarButtonWidget({
    super.key,
    required this.type,
    required this.isActive,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Expanded(
      child: SizedBox(
        height: double.infinity,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    getIconData(type: type, isFilled: isActive),
                    color: isActive ? AppTheme.primaryBackground : themeData.colorScheme.onSurface,
                    shadows: [
                      if (isActive)
                        BoxShadow(
                          color: AppTheme.primaryText,
                          offset: const Offset(1, 2),
                          blurRadius: 1,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: themeData.textTheme.bodySmall!.copyWith(
                    fontSize: isActive ? 14 : 12,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    color: isActive ? AppTheme.primaryBackground : themeData.colorScheme.onSurface,
                    shadows: [
                      if (isActive)
                        BoxShadow(
                          color: AppTheme.primaryText,
                          offset: const Offset(1, 2),
                          blurRadius: 1,
                        ),
                    ],
                  ),
                  child: Text(getLabelData(type: type)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
