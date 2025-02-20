import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/features/collections/2_domain/entity/collection.entity.dart';
import 'package:le_spawn_fr/features/collections/2_domain/entity/game-item.entity.dart';

abstract class CollectionsRepository {
  List<CollectionEntity> get collectionsCache;

  Future<Either<String, List<CollectionEntity>>> getMyCollections();

  Future<Either<String, CollectionEntity>> getCollectionById(String collectionId);

  Future<Either<String, CollectionEntity>> createCollection(String title);

  Future<Either<String, CollectionEntity>> updateCollection(String collectionId, String title);

  Future<Either<String, String>> deleteCollection(String collectionId);

  Future<Either<String, String>> deleteGameItem(GameItemEntity gameItem);
}
