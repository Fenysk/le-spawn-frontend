import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/features/collections/1_data/model/collection.model.dart';
import 'package:le_spawn_fr/features/collections/1_data/source/collections-api.service.dart';
import 'package:le_spawn_fr/features/collections/2_domain/entity/collection.entity.dart';
import 'package:le_spawn_fr/features/collections/2_domain/entity/game-item.entity.dart';
import 'package:le_spawn_fr/features/collections/2_domain/repository/collections.repository.dart';
import 'package:le_spawn_fr/service-locator.dart';

class CollectionsRepositoryImpl implements CollectionsRepository {
  List<CollectionEntity> _collectionsCache = [];

  saveToCache(List<CollectionEntity> collections) => _collectionsCache = collections;

  @override
  List<CollectionEntity> get collectionsCache => _collectionsCache;

  @override
  Future<Either<String, List<CollectionEntity>>> getMyCollections() async {
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
  }

  @override
  Future<Either<String, CollectionEntity>> getCollectionById(String collectionId) async {
    Either<String, dynamic> response = await serviceLocator<CollectionsApiService>().getCollectionById(collectionId);

    return response.fold(
      (error) => Left(error),
      (data) {
        CollectionModel collection = CollectionModel.fromMap(data);
        return Right(collection.toEntity());
      },
    );
  }

  @override
  Future<Either<String, CollectionEntity>> createCollection(String title) async {
    Either<String, dynamic> response = await serviceLocator<CollectionsApiService>().createCollection(title);

    return response.fold(
      (error) => Left(error),
      (data) {
        CollectionModel collection = CollectionModel.fromMap(data);
        return Right(collection.toEntity());
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
        return Right(collection.toEntity());
      },
    );
  }

  @override
  Future<Either<String, String>> deleteCollection(String collectionId) async {
    return await serviceLocator<CollectionsApiService>().deleteCollection(collectionId);
  }

  @override
  Future<Either<String, String>> deleteGameItem(GameItemEntity gameItem) async {
    final result = await serviceLocator<CollectionsApiService>().deleteGameItem(gameItem.id);
    return result.fold(
      (error) => Left(error),
      (success) => Right(success),
    );
  }
}
