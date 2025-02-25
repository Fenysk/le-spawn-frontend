import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service qui gère les widgets d'écran d'accueil
class HomeWidgetService {
  static const String appGroupId = 'fr.le_spawn';

  // Standardized key names
  static const String helloWorldKey = 'flutter.hello_world_text';
  static const String widgetImageKey = 'flutter.widget_image';

  // Fallback keys (used by HomeWidget API directly)
  static const String fallbackHelloWorldKey = 'hello_world_text';
  static const String fallbackWidgetImageKey = 'widget_image';

  /// Initialise le widget d'écran d'accueil
  Future<void> initHomeWidget() async {
    await HomeWidget.setAppGroupId(appGroupId);
    debugPrint('📱 Home widget initialisé avec appGroupId: $appGroupId');
  }

  /// Met à jour le texte "Hello World" sur le widget
  Future<void> updateHelloWorldWidget(String text) async {
    try {
      debugPrint('📱 Mise à jour du widget avec le texte: "$text"');

      // 1. Sauvegarder avec toutes les clés possibles pour s'assurer que le widget peut le trouver
      final prefs = await SharedPreferences.getInstance();

      // Sauvegarder avec le préfixe "flutter."
      await prefs.setString(helloWorldKey, text);
      debugPrint('📱 Texte sauvegardé avec clé $helloWorldKey: $text');

      // Sauvegarder sans préfixe également
      await prefs.setString(fallbackHelloWorldKey, text);
      debugPrint('📱 Texte sauvegardé avec clé $fallbackHelloWorldKey: $text');

      // Utiliser également l'API HomeWidget
      await HomeWidget.saveWidgetData(fallbackHelloWorldKey, text);
      await HomeWidget.saveWidgetData(helloWorldKey, text);
      debugPrint('📱 Texte sauvegardé via HomeWidget.saveWidgetData');

      // 2. Forcer la mise à jour MAINTENANT pour s'assurer que les widgets sont à jour
      await _forceWidgetUpdate();

      // 3. Debug - afficher toutes les clés pour vérification
      debugPrint('📱 === TOUTES LES CLÉS DANS SHAREDPREFERENCES ===');
      for (final key in prefs.getKeys()) {
        final value = prefs.get(key)?.toString() ?? 'null';
        debugPrint('📱 $key: $value');
      }
    } catch (e, stackTrace) {
      debugPrint('📱 Erreur lors de la mise à jour du widget: $e');
      debugPrint('📱 Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Force la mise à jour du widget
  Future<void> _forceWidgetUpdate() async {
    try {
      // Effectuer plusieurs tentatives de mise à jour
      for (int i = 0; i < 3; i++) {
        debugPrint('📱 Tentative de mise à jour du widget #${i + 1}');

        final result = await HomeWidget.updateWidget(
          name: 'HomeWidgetExampleProvider',
          androidName: 'fr.le_spawn.HomeWidgetExampleProvider',
          qualifiedAndroidName: 'fr.le_spawn.HomeWidgetExampleProvider',
        );

        debugPrint('📱 Résultat de la mise à jour #${i + 1}: $result');

        // Attendre un peu entre les tentatives
        if (i < 2) await Future.delayed(const Duration(milliseconds: 300));
      }
    } catch (e) {
      debugPrint('📱 Erreur lors de la mise à jour forcée: $e');
    }
  }
}
