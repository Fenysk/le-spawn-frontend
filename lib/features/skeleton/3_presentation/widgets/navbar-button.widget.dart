import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:le_spawn_frontend/features/skeleton/3_presentation/bloc/tabs_cubit.dart';

IconData getIconData({
  required TabType type,
  required bool isFilled,
}) =>
    switch (type) {
      TabType.home =>
        isFilled ? FluentIcons.home_32_filled : FluentIcons.home_32_regular,
      TabType.collections =>
        isFilled ? FluentIcons.search_32_filled : FluentIcons.search_32_regular,
      TabType.bank =>
        isFilled ? FluentIcons.heart_32_filled : FluentIcons.heart_32_regular,
      TabType.profile =>
        isFilled ? FluentIcons.person_32_filled : FluentIcons.person_32_regular,
    };

class NavbarButtonWidget extends StatefulWidget {
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
  State<NavbarButtonWidget> createState() => _NavbarButtonWidgetState();
}

class _NavbarButtonWidgetState extends State<NavbarButtonWidget> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        child: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: _isPressed
                ? themeData.colorScheme.surfaceVariant
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            getIconData(
              type: widget.type,
              isFilled: widget.isActive,
            ),
            color: widget.isActive
                ? themeData.colorScheme.primary
                : themeData.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
