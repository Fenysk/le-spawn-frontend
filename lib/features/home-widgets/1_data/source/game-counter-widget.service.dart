import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:le_spawn_fr/features/collections/2_domain/usecase/get-my-collections.usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:le_spawn_fr/core/di/service-locator.dart';
import 'package:le_spawn_fr/features/collections/2_domain/entity/collection.entity.dart';

class GameCounterWidgetService {
  static const String appGroupId = 'fr.le_spawn';
  static const String widgetDataKey = 'flutter.game_counter_data';
  static const String widgetImageKey = 'flutter.game_counter_image';
  static const String fallbackWidgetDataKey = 'game_counter_data';
  static const String fallbackWidgetImageKey = 'game_counter_image';

  GameCounterWidgetService();

  Future<void> initWidget() async {
    await HomeWidget.setAppGroupId(appGroupId);
  }

  /// Mise à jour du widget à partir des collections en cache (évite la boucle infinie)
  Future<void> updateWidgetDataFromCache(List<CollectionEntity> collections) async {
    try {
      // Compter le nombre total de jeux dans toutes les collections
      int totalGames = 0;
      for (final collection in collections) {
        totalGames += collection.gameItems.length;
      }

      final data = totalGames.toString();
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(widgetDataKey, data);
      await prefs.setString(fallbackWidgetDataKey, data);
      await HomeWidget.saveWidgetData(fallbackWidgetDataKey, data);
      await HomeWidget.saveWidgetData(widgetDataKey, data);
      await _forceWidgetUpdate();
    } catch (e, stackTrace) {
      debugPrint('📱 Erreur lors de la mise à jour du widget: $e');
      debugPrint('📱 Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> updateWidgetData() async {
    try {
      final response = await serviceLocator<GetMyCollectionsUsecase>().execute();
      int totalGames = 0;

      response.fold(
        (left) => debugPrint('📱 Erreur lors de la récupération des collections: $left'),
        (data) {
          for (final collection in data) {
            totalGames += collection.gameItems.length;
          }
        },
      );

      final data = totalGames.toString();
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(widgetDataKey, data);
      await prefs.setString(fallbackWidgetDataKey, data);
      await HomeWidget.saveWidgetData(fallbackWidgetDataKey, data);
      await HomeWidget.saveWidgetData(widgetDataKey, data);
      await _forceWidgetUpdate();
    } catch (e, stackTrace) {
      debugPrint('📱 Erreur lors de la mise à jour du widget: $e');
      debugPrint('📱 Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> _forceWidgetUpdate() async {
    try {
      for (int i = 0; i < 3; i++) {
        final result = await HomeWidget.updateWidget(
          name: 'GameCounterProvider',
          androidName: 'fr.le_spawn.GameCounterProvider',
          qualifiedAndroidName: 'fr.le_spawn.GameCounterProvider',
        );

        print('📱 Résultat de la mise à jour #${i + 1}: ${result}');

        if (i < 2) await Future.delayed(const Duration(milliseconds: 300));
      }
    } catch (e) {
      debugPrint('📱 Erreur lors de la mise à jour forcée: $e');
    }
  }
}
