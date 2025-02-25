package fr.le_spawn;

import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.SharedPreferences;
import android.widget.RemoteViews;
import android.util.Log;
import android.widget.Toast;

public class HomeWidgetExampleProvider extends AppWidgetProvider {
    private static final String TAG = "HomeWidgetProvider";
    private static final String SHARED_PREFS_NAME = "FlutterSharedPreferences";
    
    // Primary keys for the widget data
    private static final String HELLO_WORLD_KEY = "flutter.hello_world_text";
    
    // Alternative keys to try
    private static final String[] TEXT_KEYS = {
        "flutter.hello_world_text",
        "hello_world_text",
        "widget_hello_world_text",
        "flutter.widget_hello_world_text"
    };
    
    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        String packageName = context.getPackageName();
        Log.d(TAG, "⚡ onUpdate: Mise à jour du widget pour " + packageName);
        
        // Find resource IDs
        int textViewId = context.getResources().getIdentifier("widget_text", "id", packageName);
        int layoutId = context.getResources().getIdentifier("home_widget_layout", "layout", packageName);
        
        // Get SharedPreferences
        SharedPreferences prefs = context.getSharedPreferences(SHARED_PREFS_NAME, Context.MODE_PRIVATE);
        
        // Debug - dump all shared prefs
        Log.d(TAG, "⚡ === TOUTES LES CLÉS DE SHAREDPREFERENCES ===");
        for (String key : prefs.getAll().keySet()) {
            Object value = prefs.getAll().get(key);
            String valueStr = (value != null) ? value.toString() : "null";
            Log.d(TAG, "Clé: " + key + ", Valeur: " + valueStr);
        }
        
        // Try to read the text from multiple possible keys
        String displayText = null;
        for (String key : TEXT_KEYS) {
            if (prefs.contains(key)) {
                displayText = prefs.getString(key, null);
                if (displayText != null && !displayText.isEmpty()) {
                    Log.d(TAG, "⚡ Texte trouvé dans la clé: " + key + " = " + displayText);
                    break;
                }
            }
        }
        
        // Fallback if no text found
        if (displayText == null || displayText.isEmpty()) {
            displayText = "Hello World!";
            Log.d(TAG, "⚡ Aucun texte trouvé, utilisation de la valeur par défaut: " + displayText);
        }
        
        Log.d(TAG, "⚡ Texte final à afficher: " + displayText);
        
        // Update all widgets
        for (int appWidgetId : appWidgetIds) {
            Log.d(TAG, "⚡ Mise à jour du widget ID: " + appWidgetId);
            
            // Create RemoteViews with our custom layout
            RemoteViews views = new RemoteViews(packageName, layoutId);
            
            // Set the text
            views.setTextViewText(textViewId, displayText);
            Log.d(TAG, "⚡ Texte défini sur: " + displayText);
            
            // Update the widget
            try {
                appWidgetManager.updateAppWidget(appWidgetId, views);
                Log.d(TAG, "⚡ Widget ID " + appWidgetId + " mis à jour avec texte: " + displayText);
            } catch (Exception e) {
                Log.e(TAG, "⚡ ERREUR lors de la mise à jour du widget: " + e.getMessage());
            }
        }
        
        Toast.makeText(context, "Widget mis à jour: " + displayText, Toast.LENGTH_SHORT).show();
    }
    
    @Override
    public void onEnabled(Context context) {
        super.onEnabled(context);
        Log.d(TAG, "⚡ Widget activé!");
        Toast.makeText(context, "Widget Le Spawn activé", Toast.LENGTH_SHORT).show();
    }
    
    @Override
    public void onDisabled(Context context) {
        super.onDisabled(context);
        Log.d(TAG, "⚡ Widget désactivé!");
        Toast.makeText(context, "Widget Le Spawn désactivé", Toast.LENGTH_SHORT).show();
    }
    
    @Override
    public void onReceive(Context context, android.content.Intent intent) {
        super.onReceive(context, intent);
        Log.d(TAG, "⚡ onReceive: " + intent.getAction());
        
        // Force update when receiving any broadcast
        AppWidgetManager appWidgetManager = AppWidgetManager.getInstance(context);
        int[] appWidgetIds = appWidgetManager.getAppWidgetIds(
            new android.content.ComponentName(context, HomeWidgetExampleProvider.class));
        
        if (appWidgetIds.length > 0) {
            onUpdate(context, appWidgetManager, appWidgetIds);
        }
    }
} 