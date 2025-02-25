import 'dart:io';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:le_spawn_fr/features/home_widget/1_data/service/home_widget.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Page permettant de gérer les widgets d'écran d'accueil
class HomeWidgetPage extends StatefulWidget {
  const HomeWidgetPage({super.key});

  @override
  State<HomeWidgetPage> createState() => _HomeWidgetPageState();
}

class _HomeWidgetPageState extends State<HomeWidgetPage> {
  final HomeWidgetService _homeWidgetService = HomeWidgetService();
  final TextEditingController _textController = TextEditingController(text: "Hello World!");
  String _widgetImagePath = "Pas encore généré";
  bool _isLoading = false;
  String _statusMessage = "";
  bool _fileExists = false;
  int _fileSize = 0;
  Map<String, dynamic> _sharedPrefsContent = {};

  @override
  void initState() {
    super.initState();
    _initialiseHomeWidget();
    _checkWidgetImagePath();
    _loadSharedPreferences();
  }

  Future<void> _initialiseHomeWidget() async {
    await _homeWidgetService.initHomeWidget();

    // Écouter les événements de lancement depuis le widget
    HomeWidget.widgetClicked.listen((Uri? uri) {
      if (uri != null) {
        debugPrint('Widget clicked with URI: $uri');
        setState(() {
          _statusMessage = "Widget cliqué avec URI: $uri";
        });
        // Vous pourriez naviguer vers une page spécifique basée sur l'URI
      }
    });
  }

  Future<void> _checkWidgetImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(HomeWidgetService.widgetImageKey);

    if (path != null) {
      final file = File(path);
      final exists = await file.exists();
      int size = 0;

      if (exists) {
        size = await file.length();
      }

      setState(() {
        _widgetImagePath = path;
        _fileExists = exists;
        _fileSize = size;
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

    setState(() {
      _sharedPrefsContent = prefsContent;
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuration Widget Le Spawn'),
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
              // Section de personnalisation du widget
              Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personnalisation du widget',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          labelText: 'Texte à afficher sur le widget',
                          border: OutlineInputBorder(),
                          hintText: 'Entrez votre texte personnalisé ici',
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

              // Aperçu du widget si disponible
              if (_fileExists && _fileSize > 0) ...[
                Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aperçu du widget',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(_widgetImagePath),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

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
                      const SizedBox(height: 16),
                      _buildInstructionStep(1, 'Appuyez longuement sur un espace vide de votre écran d\'accueil'),
                      _buildInstructionStep(2, 'Sélectionnez "Widgets"'),
                      _buildInstructionStep(3, 'Recherchez "Le Spawn" ou faites défiler jusqu\'à le trouver'),
                      _buildInstructionStep(4, 'Appuyez longuement dessus et placez-le sur votre écran d\'accueil'),
                    ],
                  ),
                ),
              ),

              // Section de débogage (masquée par défaut)
              ExpansionTile(
                title: const Text('Informations de débogage'),
                initiallyExpanded: false,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Chemin de l\'image: $_widgetImagePath'),
                        Text('Le fichier existe: $_fileExists'),
                        Text('Taille du fichier: $_fileSize bytes'),
                        const Divider(),
                        Text(
                          'Contenu des SharedPreferences:',
                          style: textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        ..._sharedPrefsContent.entries
                            .map((entry) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    '${entry.key}: ${entry.value}',
                                    style: TextStyle(
                                      fontWeight: entry.key.contains('hello_world') || entry.key.contains('widget_image') ? FontWeight.bold : FontWeight.normal,
                                      color: entry.key.contains('hello_world') || entry.key.contains('widget_image') ? Colors.blue : Colors.black87,
                                      fontSize: 12,
                                    ),
                                  ),
                                ))
                            .toList(),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _checkWidgetImagePath();
                              _loadSharedPreferences();
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Actualiser les données'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.secondaryContainer,
                              foregroundColor: colorScheme.onSecondaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionStep(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text),
          ),
        ],
      ),
    );
  }

  Future<void> _updateWidget() async {
    setState(() {
      _isLoading = true;
      _statusMessage = "Mise à jour du widget en cours...";
    });

    try {
      // Tenter de récupérer l'ancienne valeur pour la comparer
      final prefs = await SharedPreferences.getInstance();
      final oldValue = prefs.getString(HomeWidgetService.helloWorldKey) ?? "Non défini";

      // Mettre à jour le widget avec le nouveau texte
      await _homeWidgetService.updateHelloWorldWidget(_textController.text);

      // Recharger les données pour afficher les mises à jour
      await _checkWidgetImagePath();
      await _loadSharedPreferences();

      // Vérifier que la nouvelle valeur est bien sauvegardée
      final newValue = prefs.getString(HomeWidgetService.helloWorldKey) ?? "Non défini";
      final successMessage = "Widget mis à jour avec succès : \"$oldValue\" → \"$newValue\"";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successMessage)),
      );
      setState(() {
        _statusMessage = successMessage;
      });

      // Forcer une dernière mise à jour du widget Android
      await HomeWidget.updateWidget(
        name: 'HomeWidgetExampleProvider',
        androidName: 'fr.le_spawn.HomeWidgetExampleProvider',
        qualifiedAndroidName: 'fr.le_spawn.HomeWidgetExampleProvider',
      );
    } catch (e) {
      final errorMessage = "Erreur lors de la mise à jour : $e";
      setState(() {
        _statusMessage = errorMessage;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _forceWidgetUpdate() async {
    setState(() {
      _isLoading = true;
      _statusMessage = "Forçage de la mise à jour du widget...";
    });

    try {
      // Récupérer la valeur actuelle pour le toast
      final prefs = await SharedPreferences.getInstance();
      final currentText = prefs.getString(HomeWidgetService.helloWorldKey) ?? "Hello World!";

      // Forcer 3 mises à jour à intervalle pour maximiser les chances de succès
      for (int i = 0; i < 3; i++) {
        await HomeWidget.updateWidget(
          name: 'HomeWidgetExampleProvider',
          androidName: 'fr.le_spawn.HomeWidgetExampleProvider',
          qualifiedAndroidName: 'fr.le_spawn.HomeWidgetExampleProvider',
        );

        if (i < 2) await Future.delayed(const Duration(milliseconds: 300));
      }

      // Actualiser les données
      await _checkWidgetImagePath();
      await _loadSharedPreferences();

      setState(() {
        _statusMessage = "Mise à jour forcée terminée. Texte actuel: \"$currentText\"";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Mise à jour forcée envoyée au widget avec le texte: "$currentText"')),
      );
    } catch (e) {
      setState(() {
        _statusMessage = "Erreur lors de la mise à jour forcée: $e";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
