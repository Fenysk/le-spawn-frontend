import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/core/di/service-locator.dart';
import 'package:le_spawn_fr/features/collections/features/new-game-item/1_data/dto/submit-game-photos.request.dart';
import 'package:le_spawn_fr/features/collections/features/new-game-item/1_data/source/game-photos-api.service.dart';
import 'package:le_spawn_fr/features/collections/features/new-game-item/2_domain/repository/new-game-item.repository.dart';

class NewGameItemRepositoryImpl implements NewGameItemRepository {
  @override
  Future<Either<String, void>> submitGamePhotos(SubmitGamePhotosRequest dto) async {
    await serviceLocator<NewGameItemApiService>().submitGamePhotos(dto);

    // TODO: Ajouter le jeu "pending" à la collection en local

    return right(null);
  }
}
