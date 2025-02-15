import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/features/collections/2_domain/entity/collection.entity.dart';

abstract class CollectionsRepository {
  Future<Either<String, List<CollectionEntity>>> getMyCollections();

  Future<Either<String, CollectionEntity>> getCollectionById(String collectionId);

  Future<Either<String, CollectionEntity>> createCollection(String title);

  Future<Either<String, CollectionEntity>> updateCollection(String collectionId, String title);

  Future<Either<String, String>> deleteCollection(String collectionId);
}
