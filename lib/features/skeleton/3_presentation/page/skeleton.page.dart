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
import 'package:le_spawn_fr/features/skeleton/3_presentation/widgets/app-loading.widget.dart';
import 'package:le_spawn_fr/features/skeleton/3_presentation/widgets/bottom-navbar.widget.dart';
import 'package:le_spawn_fr/features/skeleton/3_presentation/widgets/top-app-bar.widget.dart';
import 'package:le_spawn_fr/features/app/3_presentation/bloc/update-checker.cubit.dart';

class SkeletonPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const SkeletonPage({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<UpdateCheckerCubit>(
            create: (context) => UpdateCheckerCubit()..checkForUpdate(),
          ),
          BlocProvider<AuthCubit>(
            create: (context) => AuthCubit(),
          ),
        ],
        child: BlocBuilder<UpdateCheckerCubit, UpdateCheckerState>(
          builder: (context, updateState) {
            print(updateState.runtimeType);
            return switch (updateState) {
              UpdateCheckerLoadingState() => AppLoadingWidget(),
              UpdateCheckerNeedUpdateState() => buildUpdateRequiredContent(),
              UpdateCheckerGoodVersionState() => buildCorrectVersionContent(),
              _ => AppLoadingWidget(),
            };
          },
        ),
      ),
    );
  }

  Widget buildCorrectVersionContent() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        context.read<AuthCubit>().checkIfAuthenticated();
        return switch (state) {
          AuthLoadingState() => AppLoadingWidget(),
          UnauthenticatedState() => _handleUnauthenticated(context),
          AuthenticatedState() => _buildAuthenticatedLayout(context),
          _ => Container(color: AppTheme.accentRed),
        };
      },
    );
  }

  Widget buildUpdateRequiredContent() => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Une mise à jour est nécessaire'),
            SizedBox(height: 16),
            Text('Veuillez mettre à jour l\'application pour continuer'),
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
