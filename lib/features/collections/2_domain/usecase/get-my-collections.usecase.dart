import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/core/usecase/usecase.dart';
import 'package:le_spawn_fr/features/collections/2_domain/repository/collections.repository.dart';
import 'package:le_spawn_fr/core/di/service-locator.dart';
import 'package:le_spawn_fr/features/collections/2_domain/entity/collection.entity.dart';

class GetMyCollectionsUsecase implements Usecase<Either<String, List<CollectionEntity>>, dynamic> {
  @override
  Future<Either<String, List<CollectionEntity>>> execute({dynamic request}) async {
    return serviceLocator<CollectionsRepository>().getMyCollections();
  }
}
