import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/core/usecase/usecase.dart';
import 'package:le_spawn_fr/features/collections/2_domain/entity/game-item.entity.dart';
import 'package:le_spawn_fr/features/collections/2_domain/repository/collections.repository.dart';
import 'package:le_spawn_fr/core/di/service-locator.dart';

class DeleteGameItemUsecase implements Usecase<Either, GameItemEntity> {
  @override
  Future<Either> execute({
    GameItemEntity? request,
  }) async {
    return serviceLocator<CollectionsRepository>().deleteGameItem(request!);
  }
}
