import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:le_spawn_fr/core/configs/app-routes.config.dart';
import 'package:le_spawn_fr/core/theme/app.theme.dart';
import 'package:le_spawn_fr/features/auth/3_presentation/bloc/auth/auth.cubit.dart';
import 'package:le_spawn_fr/features/auth/3_presentation/bloc/auth/auth.state.dart';
import 'package:le_spawn_fr/features/collections/3_presentation/bloc/collections.cubit.dart';
import 'package:le_spawn_fr/features/skeleton/3_presentation/bloc/tabs_cubit.dart';
import 'package:le_spawn_fr/features/skeleton/3_presentation/bloc/tabs_state.dart';
import 'package:le_spawn_fr/features/skeleton/3_presentation/widgets/bottom-navbar.widget.dart';
import 'package:le_spawn_fr/features/skeleton/3_presentation/widgets/top-app-bar.widget.dart';

class SkeletonPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const SkeletonPage({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<AuthCubit>(
        create: (context) => AuthCubit()..appStarted(),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return switch (state) {
              AuthLoadingState() => buildLoadingContent(),
              UnauthenticatedState() => _handleUnauthenticated(context),
              AuthenticatedState() => _buildAuthenticatedLayout(context),
              _ => Container(color: AppTheme.accentRed),
            };
          },
        ),
      ),
    );
  }

  Widget buildLoadingContent() => const Center(
        child: Column(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Le Spawn'),
            CircularProgressIndicator(),
          ],
        ),
      );

  Widget _handleUnauthenticated(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go(AppRoutesConfig.auth);
    });
    return Container();
  }

  Widget _buildAuthenticatedLayout(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TabsCubit()),
        BlocProvider(create: (context) => CollectionsCubit()..loadCollections()),
      ],
      child: BlocBuilder<TabsCubit, TabsState>(
        builder: (context, tabsState) {
          return Scaffold(
            appBar: TopAppBarWidget(
              tabsState: tabsState,
            ),
            body: navigationShell,
            bottomNavigationBar: BottomNavbarWidget(
              currentIndex: navigationShell.currentIndex,
              onTabTapped: (index) => _onTabTapped(context, index),
            ),
          );
        },
      ),
    );
  }

  void _onTabTapped(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
    context.read<TabsCubit>().setTabIndex(index);
  }
}
