package fr.le_spawn;

import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.SharedPreferences;
import android.widget.RemoteViews;
import android.util.Log;

public class GameCounterProvider extends AppWidgetProvider {
    private static final String TAG = "GameCounterProvider";
    private static final String SHARED_PREFS_NAME = "FlutterSharedPreferences";

    // Clés primaires pour les données du widget
    private static final String DATA_KEY = "flutter.game_counter_data";

    // Clés alternatives à essayer
    private static final String[] DATA_KEYS = {
        "flutter.game_counter_data",
        "game_counter_data",
        "widget_game_counter_data",
        "flutter.widget_game_counter_data"
    };

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        String packageName = context.getPackageName();
        Log.d(TAG, "⚡ onUpdate: Mise à jour du widget pour " + packageName);

        // Trouver les IDs des ressources
        int widgetMainViewId = context.getResources().getIdentifier("widget_main_view", "id", packageName);
        int layoutId = context.getResources().getIdentifier("game_counter_widget", "layout", packageName);

        // Récupérer les SharedPreferences
        SharedPreferences prefs = context.getSharedPreferences(SHARED_PREFS_NAME, Context.MODE_PRIVATE);

        // Debug - afficher toutes les clés de SharedPreferences
        Log.d(TAG, "⚡ === TOUTES LES CLÉS DE SHAREDPREFERENCES ===");
        for (String key : prefs.getAll().keySet()) {
            Object value = prefs.getAll().get(key);
            String valueStr = (value != null) ? value.toString() : "null";
            Log.d(TAG, "Clé: " + key + ", Valeur: " + valueStr);
        }

        // Essayer de lire les données depuis plusieurs clés possibles
        String displayData = null;
        for (String key : DATA_KEYS) {
            if (prefs.contains(key)) {
                displayData = prefs.getString(key, null);
                if (displayData != null && !displayData.isEmpty()) {
                    Log.d(TAG, "⚡ Données trouvées dans la clé: " + key + " = " + displayData);
                    break;
                }
            }
        }

        // Valeur par défaut si aucune donnée trouvée
        if (displayData == null || displayData.isEmpty()) {
            displayData = "0";
            Log.d(TAG, "⚡ Aucune donnée trouvée, utilisation de la valeur par défaut: " + displayData);
        }

        Log.d(TAG, "⚡ Données finales à afficher: " + displayData);

        // Mettre à jour tous les widgets
        for (int appWidgetId : appWidgetIds) {
            Log.d(TAG, "⚡ Mise à jour du widget ID: " + appWidgetId);

            // Créer RemoteViews avec notre layout personnalisé
            RemoteViews views = new RemoteViews(packageName, layoutId);

            // Mettre à jour les données
            views.setTextViewText(context.getResources().getIdentifier("widget_text", "id", packageName), displayData);

            // Mettre à jour le widget
            try {
                appWidgetManager.updateAppWidget(appWidgetId, views);
                Log.d(TAG, "⚡ Widget ID " + appWidgetId + " mis à jour avec les données: " + displayData);
            } catch (Exception e) {
                Log.e(TAG, "⚡ ERREUR lors de la mise à jour du widget: " + e.getMessage());
            }
        }
    }

    @Override
    public void onEnabled(Context context) {
        super.onEnabled(context);
        Log.d(TAG, "⚡ Widget Compteur de Jeux activé!");
    }

    @Override
    public void onDisabled(Context context) {
        super.onDisabled(context);
        Log.d(TAG, "⚡ Widget Compteur de Jeux désactivé!");
    }

    @Override
    public void onReceive(Context context, android.content.Intent intent) {
        super.onReceive(context, intent);
        Log.d(TAG, "⚡ onReceive: " + intent.getAction());

        // Forcer la mise à jour lors de la réception d'un broadcast
        AppWidgetManager appWidgetManager = AppWidgetManager.getInstance(context);
        int[] appWidgetIds = appWidgetManager.getAppWidgetIds(
            new android.content.ComponentName(context, GameCounterProvider.class));

        if (appWidgetIds.length > 0) {
            onUpdate(context, appWidgetManager, appWidgetIds);
        }
    }
}