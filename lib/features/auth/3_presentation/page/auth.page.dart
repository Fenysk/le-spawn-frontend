import 'package:flutter/material.dart';
import 'package:le_spawn_frontend/features/auth/3_presentation/widget/login.tab.dart';
import 'package:le_spawn_frontend/features/auth/3_presentation/widget/register.tab.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void switchToLoginTab() {
    _tabController.animateTo(1);
  }

  void switchToRegisterTab() {
    _tabController.animateTo(0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: true,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 2 / 9),
                Text(
                  'Le Spawn, l\'application ultime\npour les collectionneurs !',
                  style: themeData.textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              RegisterTab(onGoToLoginTab: switchToLoginTab),
                              LoginTab(onGoToRegisterTab: switchToRegisterTab),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
