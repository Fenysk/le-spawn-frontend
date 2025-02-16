import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/features/collections/2_domain/entity/game-item.entity.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/1_data/dto/add-new-game-to-collection.request.dart';

abstract class NewItemRepository {
  Future<Either<String, GameItemEntity>> addGameToCollection(AddGameItemToCollectionRequest dto);
}
