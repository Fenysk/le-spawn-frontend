import 'package:flutter/material.dart';
import 'package:le_spawn_fr/features/skeleton/3_presentation/bloc/tabs_cubit.dart';
import 'package:le_spawn_fr/features/skeleton/3_presentation/widgets/navbar-button.widget.dart';

class BottomNavbarWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  const BottomNavbarWidget({
    super.key,
    required this.currentIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      padding: const EdgeInsets.all(0),
      height: 70,
      color: Theme.of(context).colorScheme.primary,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          constraints: const BoxConstraints(maxWidth: 400),
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
      ),
    );
  }
}
