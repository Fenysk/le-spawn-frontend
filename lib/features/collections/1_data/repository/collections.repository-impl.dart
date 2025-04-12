import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/features/collections/1_data/model/collection.model.dart';
import 'package:le_spawn_fr/features/home-widgets/1_data/source/game-counter-widget.service.dart';
import 'package:le_spawn_fr/features/collections/1_data/source/collections-api.service.dart';
import 'package:le_spawn_fr/features/collections/2_domain/entity/collection.entity.dart';
import 'package:le_spawn_fr/features/collections/2_domain/entity/game-item.entity.dart';
import 'package:le_spawn_fr/features/collections/2_domain/repository/collections.repository.dart';
import 'package:le_spawn_fr/core/di/service-locator.dart';

class CollectionsRepositoryImpl implements CollectionsRepository {
  List<CollectionEntity> _collectionsCache = [];
  bool _isUpdatingWidget = false; // Flag pour éviter les boucles infinies

  saveToCache(List<CollectionEntity> collections) {
    _collectionsCache = collections;
    _updateHomeWidget();
  }

  // Mettre à jour le widget d'accueil avec le nombre de jeux
  Future<void> _updateHomeWidget() async {
    try {
      // Éviter la boucle infinie
      if (_isUpdatingWidget) return;

      // Si le service est enregistré, mettre à jour le widget
      if (serviceLocator.isRegistered<GameCounterWidgetService>()) {
        _isUpdatingWidget = true; // Définir le flag
        await serviceLocator<GameCounterWidgetService>().updateWidgetDataFromCache(_collectionsCache);
        _isUpdatingWidget = false; // Réinitialiser le flag
      }
    } catch (e) {
      _isUpdatingWidget = false; // Réinitialiser le flag en cas d'erreur
      // Ignorer les erreurs car le widget est optionnel
      print('Failed to update home widget: $e');
    }
  }

  @override
  List<CollectionEntity> get collectionsCache => _collectionsCache;

  @override
  Future<Either<String, List<CollectionEntity>>> getMyCollections() async {
    try {
      Either<String, List<dynamic>> response = await serviceLocator<CollectionsApiService>().getMyCollections();

      return response.fold(
        (error) => Left(error),
        (data) {
          List<CollectionModel> collections = data.map((item) => CollectionModel.fromMap(item)).toList();
          List<CollectionEntity> collectionEntities = collections.map((model) => model.toEntity()).toList();
          saveToCache(collectionEntities);
          return Right(collectionEntities);
        },
      );
    } catch (e) {
      return Left('Failed to get collections: $e');
    }
  }

  @override
  Future<Either<String, CollectionEntity>> getCollectionById(String collectionId) async {
    try {
      // Then try from API
      Either<String, dynamic> response = await serviceLocator<CollectionsApiService>().getCollectionById(collectionId);

      return response.fold(
        (error) => Left(error),
        (data) {
          CollectionModel collection = CollectionModel.fromMap(data);
          final collectionEntity = collection.toEntity();

          // Update the widget if needed
          _updateHomeWidget();

          return Right(collectionEntity);
        },
      );
    } catch (e) {
      return Left('Failed to get collection: $e');
    }
  }

  @override
  Future<Either<String, CollectionEntity>> createCollection(String title) async {
    Either<String, dynamic> response = await serviceLocator<CollectionsApiService>().createCollection(title);

    return response.fold(
      (error) => Left(error),
      (data) {
        CollectionModel collection = CollectionModel.fromMap(data);
        final collectionEntity = collection.toEntity();

        // Update cache
        _collectionsCache = [
          ..._collectionsCache,
          collectionEntity
        ];

        // Update the widget
        _updateHomeWidget();

        return Right(collectionEntity);
      },
    );
  }

  @override
  Future<Either<String, CollectionEntity>> updateCollection(String collectionId, String title) async {
    Either<String, dynamic> response = await serviceLocator<CollectionsApiService>().updateCollection(collectionId, title);

    return response.fold(
      (error) => Left(error),
      (data) {
        CollectionModel collection = CollectionModel.fromMap(data);
        final collectionEntity = collection.toEntity();

        // Update cache
        _collectionsCache = _collectionsCache.map((c) => c.id == collectionId ? collectionEntity : c).toList();

        // Update the widget
        _updateHomeWidget();

        return Right(collectionEntity);
      },
    );
  }

  @override
  Future<Either<String, String>> deleteCollection(String collectionId) async {
    final result = await serviceLocator<CollectionsApiService>().deleteCollection(collectionId);

    return result.fold(
      (error) => Left(error),
      (success) {
        // Update cache
        _collectionsCache = _collectionsCache.where((c) => c.id != collectionId).toList();

        // Update the widget
        _updateHomeWidget();

        return Right(success);
      },
    );
  }

  @override
  Future<Either<String, String>> deleteGameItem(GameItemEntity gameItem) async {
    final result = await serviceLocator<CollectionsApiService>().deleteGameItem(gameItem.id);

    return result.fold(
      (error) => Left(error),
      (success) {
        // Update the collection in local storage by removing the game item
        final affectedCollection = _collectionsCache.firstWhere(
          (c) => c.id == gameItem.collectionId,
          orElse: () => CollectionEntity.empty(),
        );

        if (affectedCollection.id.isNotEmpty) {
          final updatedCollection = CollectionEntity(
            id: affectedCollection.id,
            title: affectedCollection.title,
            gameItems: affectedCollection.gameItems.where((g) => g.id != gameItem.id).toList(),
            userId: affectedCollection.userId,
          );

          // Update cache
          _collectionsCache = _collectionsCache.map((c) => c.id == gameItem.collectionId ? updatedCollection : c).toList();

          // Update the widget
          _updateHomeWidget();
        }

        return Right(success);
      },
    );
  }
}
