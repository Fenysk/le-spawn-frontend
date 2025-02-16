import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/features/collections/1_data/model/game-item.model.dart';
import 'package:le_spawn_fr/features/collections/2_domain/entity/game-item.entity.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/1_data/dto/add-new-game-to-collection.request.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/1_data/source/new-item-api.service.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/2_domain/repository/new-item.repository.dart';
import 'package:le_spawn_fr/service-locator.dart';

class NewItemRepositoryImpl implements NewItemRepository {
  @override
  Future<Either<String, GameItemEntity>> addGameToCollection(AddGameItemToCollectionRequest dto) async {
    Either<String, dynamic> response = await serviceLocator<NewItemApiService>().addGameToCollection(dto);

    return response.fold(
      (error) => Left(error),
      (data) {
        GameItemModel gameCollectionItem = GameItemModel.fromMap(data);
        return Right(gameCollectionItem.toEntity());
      },
    );
  }
}
