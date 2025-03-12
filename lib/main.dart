import 'dart:async';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:home_widget/home_widget.dart';
import 'package:le_spawn_fr/core/configs/go-router.config.dart';
import 'package:le_spawn_fr/core/constant/image.constant.dart';
import 'package:le_spawn_fr/core/theme/app.theme.dart';
import 'package:le_spawn_fr/core/di/service-locator.dart';
import 'package:rive/rive.dart' show RiveFile;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  try {
    await dotenv.load();
  } catch (error) {
    print('Error loading .env file: $error');
  }

  setupServiceLocator();

  await _initHomeWidget();

  unawaited(RiveFile.initialize());

  runApp(
    const MainApp(),
  );
}

Future<void> _initHomeWidget() async {
  try {
    await HomeWidget.setAppGroupId('fr.le_spawn');

    HomeWidget.widgetClicked.listen((Uri? uri) {
      if (uri != null) {
        debugPrint('Widget cliqué avec URI: $uri');
      }
    });
  } catch (e) {
    debugPrint('Erreur lors de l\'initialisation du home widget: $e');
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FlutterSplashScreen.scale(
        childWidget: Image.asset(
          ImageConstant.joystickPath,
          width: MediaQuery.of(context).size.width * 0.7,
        ),
        animationDuration: const Duration(milliseconds: 500),
        backgroundColor: AppTheme.accentRed,
        nextScreen: MaterialApp.router(
          title: 'Le Spawn',
          routerConfig: goRouterConfig,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            ...GlobalMaterialLocalizations.delegates,
            GlobalMaterialLocalizations.delegate,
          ],
          themeMode: ThemeMode.light,
          theme: AppTheme.leSpawnTheme,
        ),
      ),
    );
  }
}
