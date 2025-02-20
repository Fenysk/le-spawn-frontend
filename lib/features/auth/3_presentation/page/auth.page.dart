import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:le_spawn_fr/core/constant/image.constant.dart';
import 'package:le_spawn_fr/features/auth/2_domain/usecase/login-with-google.usecase.dart';
import 'package:le_spawn_fr/features/auth/3_presentation/tab/login.tab.dart';
import 'package:le_spawn_fr/features/auth/3_presentation/tab/register.tab.dart';
import 'package:le_spawn_fr/service-locator.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _showSocialLogin = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _showSocialLogin = Platform.isIOS || Platform.isAndroid;
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        top: true,
        bottom: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: _showSocialLogin ? 150 : 80,
                child: Center(
                  child: Image.asset(
                    ImageConstant.logoTextTransparentPath,
                    height: 70,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Flexible(
              child: Column(
                children: [
                  Flexible(
                    child: _showSocialLogin ? buildSocialContent() : buildCredentialsContent(),
                  ),
                  if (Platform.isAndroid || Platform.isIOS) buildSwitchButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSwitchButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: TextButton.icon(
        onPressed: () => setState(() => _showSocialLogin = !_showSocialLogin),
        icon: Icon(_showSocialLogin ? FluentIcons.arrow_right_16_regular : FluentIcons.arrow_left_16_regular, color: Colors.white),
        label: Text(_showSocialLogin ? "Utiliser un email & mot de passe" : "Se connecter autrement", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget buildCredentialsContent() {
    return Container(
      margin: const EdgeInsets.only(top: 32, left: 32, right: 32),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: Colors.white,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 500),
        child: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            RegisterTab(onGoToLoginTab: switchToLoginTab),
            LoginTab(onGoToRegisterTab: switchToRegisterTab),
          ],
        ),
      ),
    );
  }

  Widget buildSocialContent() {
    return Padding(
      padding: const EdgeInsets.only(top: 100, bottom: 32, left: 50, right: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            icon: const Icon(
              IonIcons.logo_google,
              color: Colors.black,
            ),
            label: const Text("Continuer avec Google", style: TextStyle(color: Colors.black)),
            onPressed: () => serviceLocator<LoginWithGoogleUsecase>().execute(),
          ),
          const SizedBox(height: 16),
          IgnorePointer(
            child: Opacity(
              opacity: 0.7,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                icon: const Icon(
                  IonIcons.logo_apple,
                  color: Colors.white,
                ),
                label: const Text(
                  "Continuer avec Apple (Bientôt)",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
