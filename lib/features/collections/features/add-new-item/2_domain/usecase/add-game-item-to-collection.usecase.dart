import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/core/usecase/usecase.dart';
import 'package:le_spawn_fr/features/collections/2_domain/entity/game-item.entity.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/1_data/dto/add-new-game-to-collection.request.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/2_domain/repository/new-item.repository.dart';
import 'package:le_spawn_fr/service-locator.dart';

class AddGameItemToCollectionUsecase implements Usecase<Either<String, GameItemEntity>, AddGameItemToCollectionRequest> {
  @override
  Future<Either<String, GameItemEntity>> execute({
    AddGameItemToCollectionRequest? request,
  }) async {
    return serviceLocator<NewItemRepository>().addGameToCollection(request!);
  }
}
