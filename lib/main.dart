import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:le_spawn_frontend/core/configs/app-router.config.dart';
import 'package:le_spawn_frontend/service-locator.dart';

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
    return MaterialApp.router(
      title: 'Le Spawn',
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        ...GlobalMaterialLocalizations.delegates,
        GlobalMaterialLocalizations.delegate,
      ],
      themeMode: ThemeMode.system,
    );
  }
}
