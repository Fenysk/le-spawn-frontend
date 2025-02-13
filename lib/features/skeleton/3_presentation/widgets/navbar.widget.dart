import 'package:flutter/material.dart';
import 'package:le_spawn_frontend/features/skeleton/3_presentation/bloc/tabs_cubit.dart';
import 'package:le_spawn_frontend/features/skeleton/3_presentation/bloc/tabs_state.dart';
import 'package:le_spawn_frontend/features/skeleton/3_presentation/widgets/navbar-button.widget.dart';

class NavbarWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  const NavbarWidget({
    super.key,
    required this.currentIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NavbarButtonWidget(
              type: TabType.collections,
              isActive: currentIndex == 0,
              onTap: () => onTabTapped(0),
            ),
            NavbarButtonWidget(
              type: TabType.bank,
              isActive: currentIndex == 1,
              onTap: () => onTabTapped(1),
            ),
            NavbarButtonWidget(
              type: TabType.profile,
              isActive: currentIndex == 2,
              onTap: () => onTabTapped(2),
            ),
          ],
        ),
      ),
    );
  }
}
