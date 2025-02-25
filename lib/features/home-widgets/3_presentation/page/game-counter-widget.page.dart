import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:le_spawn_fr/core/di/service-locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:le_spawn_fr/features/home-widgets/1_data/source/game-counter-widget.service.dart';
import 'package:le_spawn_fr/features/collections/2_domain/usecase/get-my-collections.usecase.dart';

class GameCounterWidgetPage extends StatefulWidget {
  const GameCounterWidgetPage({super.key});

  @override
  State<GameCounterWidgetPage> createState() => _GameCounterWidgetPageState();
}

class _GameCounterWidgetPageState extends State<GameCounterWidgetPage> {
  late final GameCounterWidgetService _widgetService;
  bool _isLoading = false;
  String _statusMessage = "";
  int _totalGames = 0;

  @override
  void initState() {
    super.initState();
    _widgetService = serviceLocator<GameCounterWidgetService>();
    _initialiseWidget();
    _loadTotalGames();
    _loadSharedPreferences();
  }

  Future<void> _initialiseWidget() async {
    await _widgetService.initWidget();

    // Écouter les événements de lancement depuis le widget
    HomeWidget.widgetClicked.listen((Uri? uri) {
      if (uri != null) {
        debugPrint('Widget cliqué avec URI: $uri');
        setState(() {
          _statusMessage = "Widget cliqué avec URI: $uri";
        });
      }
    });
  }

  Future<void> _loadTotalGames() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final result = await serviceLocator<GetMyCollectionsUsecase>().execute();

      int total = 0;

      result.fold(
        (error) => debugPrint('Erreur lors du chargement des collections: $error'),
        (data) => total = data.map((collection) => collection.gameItems.length).reduce((a, b) => a + b),
      );

      setState(() {
        _totalGames = total;
      });
    } catch (e) {
      debugPrint('Erreur lors du chargement du nombre total de jeux: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> prefsContent = {};

    // Récupérer toutes les clés et valeurs
    for (final key in prefs.getKeys()) {
      if (prefs.containsKey(key)) {
        var value = "non défini";
        if (prefs.getString(key) != null) {
          value = prefs.getString(key)!;
        } else if (prefs.getInt(key) != null) {
          value = prefs.getInt(key).toString();
        } else if (prefs.getBool(key) != null) {
          value = prefs.getBool(key).toString();
        } else if (prefs.getDouble(key) != null) {
          value = prefs.getDouble(key).toString();
        } else if (prefs.getStringList(key) != null) {
          value = prefs.getStringList(key).toString();
        }
        prefsContent[key] = value;
      }
    }

    setState(() {});
  }

  Future<void> _updateWidget() async {
    try {
      setState(() {
        _isLoading = true;
        _statusMessage = "Mise à jour en cours...";
      });

      // Obtenir d'abord les collections
      final result = await serviceLocator<GetMyCollectionsUsecase>().execute();

      // Utiliser la méthode updateWidgetDataFromCache pour éviter la boucle
      result.fold(
        (error) {
          debugPrint('Erreur lors du chargement des collections: $error');
          setState(() {
            _statusMessage = "Erreur: $error";
          });
        },
        (collections) async {
          await _widgetService.updateWidgetDataFromCache(collections);
          setState(() {
            _statusMessage = "Widget mis à jour avec succès!";
          });
        },
      );

      // Actualiser les SharedPreferences affichées
      await _loadSharedPreferences();
    } catch (e) {
      setState(() {
        _statusMessage = "Erreur: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _forceWidgetUpdate() async {
    try {
      setState(() {
        _isLoading = true;
        _statusMessage = "Forçage de la mise à jour...";
      });

      final result = await HomeWidget.updateWidget(
        name: 'GameCounterProvider',
        androidName: 'fr.le_spawn.GameCounterProvider',
        qualifiedAndroidName: 'fr.le_spawn.GameCounterProvider',
      );

      setState(() {
        _statusMessage = "Mise à jour forcée: $result";
      });
    } catch (e) {
      setState(() {
        _statusMessage = "Erreur de mise à jour forcée: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuration Widget Compteur de Jeux'),
        actions: [
          IconButton(
            onPressed: _forceWidgetUpdate,
            icon: const Icon(Icons.refresh),
            tooltip: 'Forcer la mise à jour du widget',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Section d'information
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Compteur de Jeux',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              'Jeux dans votre collection',
                              style: textTheme.titleSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _isLoading ? 'Chargement...' : '$_totalGames',
                              style: textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: _isLoading ? null : _updateWidget,
                          icon: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2.0),
                                )
                              : const Icon(Icons.update),
                          label: Text(_isLoading ? 'Mise à jour en cours...' : 'Mettre à jour le widget'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Statut et aide
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Statut et aide',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _statusMessage.contains('succès') ? Colors.green.withOpacity(0.1) : Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _statusMessage.contains('succès') ? Icons.check_circle : Icons.info_outline,
                              color: _statusMessage.contains('succès') ? Colors.green : Colors.blue,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _statusMessage.isEmpty ? 'Prêt à mettre à jour' : _statusMessage,
                                style: textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Note: Après avoir mis à jour le widget, vous devrez peut-être attendre quelques instants ou toucher le widget sur votre écran d\'accueil pour qu\'il se mette à jour. Si cela ne fonctionne pas, essayez de supprimer et de rajouter le widget.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              // Instructions pour ajouter le widget
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Comment ajouter le widget',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const ListTile(
                        leading: CircleAvatar(child: Text('1')),
                        title: Text('Appuyez longuement sur l\'écran d\'accueil'),
                        contentPadding: EdgeInsets.zero,
                      ),
                      const ListTile(
                        leading: CircleAvatar(child: Text('2')),
                        title: Text('Sélectionnez "Widgets"'),
                        contentPadding: EdgeInsets.zero,
                      ),
                      const ListTile(
                        leading: CircleAvatar(child: Text('3')),
                        title: Text('Trouvez "Le Spawn - Compteur de Jeux"'),
                        contentPadding: EdgeInsets.zero,
                      ),
                      const ListTile(
                        leading: CircleAvatar(child: Text('4')),
                        title: Text('Glissez-le sur votre écran d\'accueil'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
