import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:le_spawn_fr/core/configs/app-routes.config.dart';
import 'package:le_spawn_fr/core/constant/image.constant.dart';
import 'package:le_spawn_fr/features/onboarding/3_presentation/tab/welcome.tab.dart';
import 'package:le_spawn_fr/features/user/3_presentation/bloc/user-display.cubit.dart';
import 'package:le_spawn_fr/features/user/3_presentation/bloc/user-display.state.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    return Scaffold(
      backgroundColor: appTheme.colorScheme.primary,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: 120,
                child: Center(
                  child: Image.asset(
                    ImageConstant.logoTextTransparentPath,
                    height: 70,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocProvider(
                create: (context) => UserDisplayCubit()..displayUser(),
                child: BlocBuilder<UserDisplayCubit, UserDisplayState>(
                  builder: (context, state) {
                    return switch (state) {
                      UserDisplayLoaded() => buildLoadedContent(state),
                      UserDisplayFailure() => buildFailureContent(state),
                      _ => buildLoadingContent(),
                    };
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoadedContent(UserDisplayLoaded state) {
    return Padding(
      padding: const EdgeInsets.only(top: 64),
      child: WelcomeTab(
        onScanFirstGamePressed: goToAddNewItemInCollectionPage,
      ),
    );
  }

  void goToAddNewItemInCollectionPage() => context.goNamed("${AppRoutesConfig.collections}/${AppRoutesConfig.addNewGamePath}");

  Widget buildFailureContent(UserDisplayFailure state) {
    return Placeholder();
  }

  Widget buildLoadingContent() {
    return Placeholder();
  }
}
