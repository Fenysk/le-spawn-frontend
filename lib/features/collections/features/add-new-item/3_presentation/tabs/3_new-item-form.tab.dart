import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:le_spawn_fr/core/configs/app-routes.config.dart';
import 'package:le_spawn_fr/core/constant/items.constant.dart';
import 'package:le_spawn_fr/core/widgets/image-overlay.widget.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';
import 'package:le_spawn_fr/features/collections/2_domain/repository/collections.repository.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/2_domain/usecase/add-game-item-to-collection.usecase.dart';
import 'package:le_spawn_fr/core/di/service-locator.dart';
import 'package:soft_edge_blur/soft_edge_blur.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/1_data/dto/add-new-game-to-collection.request.dart';

class NewItemFormTab extends StatefulWidget {
  final GameEntity game;

  const NewItemFormTab({super.key, required this.game});

  @override
  State<NewItemFormTab> createState() => _NewItemFormTabState();
}

class _NewItemFormTabState extends State<NewItemFormTab> {
  final _formKey = GlobalKey<FormState>();
  bool _hasBox = false;
  bool _hasGame = false;
  bool _hasPaper = false;

  double? _stateBox;
  double? _stateGame;
  double? _statePaper;

  Future<void> _submitForm() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final dto = AddGameItemToCollectionRequest(
      collectionId: serviceLocator<CollectionsRepository>().collectionsCache.first.id,
      gameId: widget.game.id,
      hasBox: _hasBox,
      hasGame: _hasGame,
      hasPaper: _hasPaper,
      stateBox: _hasBox ? ItemsConstant.states[_stateBox!.round()] : null,
      stateGame: _hasGame ? ItemsConstant.states[_stateGame!.round()] : null,
      statePaper: _hasPaper ? ItemsConstant.states[_statePaper!.round()] : null,
    );

    final response = await serviceLocator<AddGameItemToCollectionUsecase>().execute(request: dto);

    response.fold(
      (failure) => _showErrorSnackBar(failure),
      (_) => _navigateToCollections(),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _navigateToCollections() {
    context.goNamed(
      AppRoutesConfig.collections,
      queryParameters: {
        'shouldRefresh': 'true'
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildImageOverlay(),
        Expanded(
          child: _buildForm(),
        ),
      ],
    );
  }

  Widget _buildImageOverlay() {
    return ImageOverlay(
      image: widget.game.coverUrl!,
      distance: 0.4,
      sides: const [
        EdgeType.bottomEdge
      ],
      color: Colors.white,
      height: 150,
      disableGradient: false,
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSwitchListTile(
                  'Has Box',
                  _hasBox,
                  (value) => setState(() {
                        _hasBox = value;
                        _stateBox = value ? 1.0 : null;
                      })),
              _buildSwitchListTile(
                  'Has Game',
                  _hasGame,
                  (value) => setState(() {
                        _hasGame = value;
                        _stateGame = value ? 1.0 : null;
                      })),
              _buildSwitchListTile(
                  'Has Paper',
                  _hasPaper,
                  (value) => setState(() {
                        _hasPaper = value;
                        _statePaper = value ? 1.0 : null;
                      })),
              const SizedBox(height: 24),
              if (_hasBox) _buildStateSlider('State Box', _stateBox!, (value) => _stateBox = value, key: UniqueKey()),
              if (_hasGame) _buildStateSlider('State Game', _stateGame!, (value) => _stateGame = value, key: UniqueKey()),
              if (_hasPaper) _buildStateSlider('State Paper', _statePaper!, (value) => _statePaper = value, key: UniqueKey()),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchListTile(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildStateSlider(String title, double value, ValueChanged<double> onChanged, {required Key key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$title: ${ItemsConstant.states[value.round()]}'),
        Slider(
          value: value,
          min: 0,
          max: 3,
          divisions: 3,
          onChanged: (double newValue) {
            setState(() {
              onChanged(newValue);
            });
          },
        ),
      ],
    );
  }
}
