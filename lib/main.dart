import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:le_spawn_fr/core/configs/go-router.config.dart';
import 'package:le_spawn_fr/core/constant/image.constant.dart';
import 'package:le_spawn_fr/core/theme/app.theme.dart';
import 'package:le_spawn_fr/service-locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load();
  } catch (error) {
    print('Error loading .env file: $error');
  }

  setupServiceLocator();

  runApp(
    const MainApp(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FlutterSplashScreen.scale(
        childWidget: Image.asset(
          ImageConstant.joystickPath,
          width: MediaQuery.of(context).size.width * 0.7,
        ),
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
