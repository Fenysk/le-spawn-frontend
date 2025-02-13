import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:le_spawn_frontend/core/configs/app-routes.config.dart';
import 'package:le_spawn_frontend/features/auth/3_presentation/page/auth.page.dart';
import 'package:le_spawn_frontend/features/bank/3_presentation/page/bank.page.dart';
import 'package:le_spawn_frontend/features/collections/3_presentation/page/collections.page.dart';
import 'package:le_spawn_frontend/features/skeleton/3_presentation/page/skeleton.page.dart';
import 'package:le_spawn_frontend/features/user/3_presentation/page/profile.page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _collectionsNavigatorKey = GlobalKey<NavigatorState>();
final _bankNavigatorKey = GlobalKey<NavigatorState>();
final _profileNavigatorKey = GlobalKey<NavigatorState>();

final goRouterConfig = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutesConfig.collections,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutesConfig.auth,
      name: AppRoutesConfig.auth,
      builder: (context, state) => const AuthPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return SkeletonPage(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _collectionsNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutesConfig.collections,
              name: AppRoutesConfig.collections,
              builder: (context, state) => const CollectionsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _bankNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutesConfig.bank,
              name: AppRoutesConfig.bank,
              builder: (context, state) => const BankPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _profileNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutesConfig.profile,
              name: AppRoutesConfig.profile,
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => const Scaffold(
    body: Center(
      child: Text('Page not found'),
    ),
  ),
);
