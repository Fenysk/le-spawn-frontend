import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:le_spawn_fr/core/configs/app-routes.config.dart';
import 'package:le_spawn_fr/core/widgets/image-overlay.widget.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/entity/game.entity.dart';
import 'package:le_spawn_fr/features/collections/2_domain/repository/collections.repository.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/2_domain/usecase/add-game-item-to-collection.usecase.dart';
import 'package:le_spawn_fr/service-locator.dart';
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
  final TextEditingController _stateBoxController = TextEditingController();
  final TextEditingController _stateGameController = TextEditingController();
  final TextEditingController _statePaperController = TextEditingController();
  bool _hasBox = false;
  bool _hasGame = false;
  bool _hasPaper = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ImageOverlay(
          image: widget.game.coverUrl!,
          distance: 0.4,
          sides: [
            EdgeType.bottomEdge
          ],
          color: Colors.white,
          height: 150,
          disableGradient: false,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SwitchListTile(
                      title: Text('Has Box'),
                      value: _hasBox,
                      onChanged: (bool value) {
                        setState(() {
                          _hasBox = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: Text('Has Game'),
                      value: _hasGame,
                      onChanged: (bool value) {
                        setState(() {
                          _hasGame = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: Text('Has Paper'),
                      value: _hasPaper,
                      onChanged: (bool value) {
                        setState(() {
                          _hasPaper = value;
                        });
                      },
                    ),
                    TextFormField(
                      controller: _stateBoxController,
                      decoration: InputDecoration(labelText: 'State Box'),
                    ),
                    TextFormField(
                      controller: _stateGameController,
                      decoration: InputDecoration(labelText: 'State Game'),
                    ),
                    TextFormField(
                      controller: _statePaperController,
                      decoration: InputDecoration(labelText: 'State Paper'),
                    ),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _submitForm() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final dto = AddGameItemToCollectionRequest(
      collectionId: serviceLocator<CollectionsRepository>().collectionsCache.first.id,
      gameId: widget.game.id,
      hasBox: _hasBox,
      hasGame: _hasGame,
      hasPaper: _hasPaper,
      stateBox: _stateBoxController.text,
      stateGame: _stateGameController.text,
      statePaper: _statePaperController.text,
    );

    final response = await serviceLocator<AddGameItemToCollectionUsecase>().execute(request: dto);

    response.fold(
      (failure) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(failure),
          backgroundColor: Colors.red,
        ),
      ),
      (_) => context.goNamed(AppRoutesConfig.collections, queryParameters: {
        'shouldRefresh': 'true'
      }),
    );
  }
}
