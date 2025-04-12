import 'package:get_it/get_it.dart';
import 'package:le_spawn_fr/features/collections/1_data/repository/collections.repository-impl.dart';
import 'package:le_spawn_fr/features/collections/1_data/source/collections-api.service.dart';
import 'package:le_spawn_fr/features/collections/2_domain/repository/collections.repository.dart';
import 'package:le_spawn_fr/features/collections/2_domain/usecase/delete-game-item.usecase.dart';
import 'package:le_spawn_fr/features/collections/2_domain/usecase/get-my-collections.usecase.dart';
import 'package:le_spawn_fr/features/collections/features/new-game-item/1_data/repository/new-game-item.repository-impl.dart';
import 'package:le_spawn_fr/features/collections/features/new-game-item/1_data/source/game-photos-api.service.dart';
import 'package:le_spawn_fr/features/collections/features/new-game-item/2_domain/repository/new-game-item.repository.dart';
import 'package:le_spawn_fr/features/collections/features/new-game-item/2_domain/usecase/submit-game-photos.usecase.dart';

class CollectionsModule {
  static void init(GetIt sl) {
    // Services
    sl.registerSingleton<CollectionsApiService>(CollectionsApiServiceImpl());
    sl.registerSingleton<NewGameItemApiService>(NewGameItemApiServiceImpl());

    // Repositories
    sl.registerSingleton<CollectionsRepository>(CollectionsRepositoryImpl());
    sl.registerSingleton<NewGameItemRepository>(NewGameItemRepositoryImpl());

    // Usecases
    sl.registerSingleton<GetMyCollectionsUsecase>(GetMyCollectionsUsecase());
    sl.registerSingleton<DeleteGameItemUsecase>(DeleteGameItemUsecase());
    sl.registerSingleton<SubmitGamePhotosUsecase>(SubmitGamePhotosUsecase());
  }
}
