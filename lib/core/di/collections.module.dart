import 'package:get_it/get_it.dart';
import 'package:le_spawn_fr/features/collections/1_data/repository/collections.repository-impl.dart';
import 'package:le_spawn_fr/features/collections/1_data/source/collections-api.service.dart';
import 'package:le_spawn_fr/features/collections/2_domain/repository/collections.repository.dart';
import 'package:le_spawn_fr/features/collections/2_domain/usecase/delete-game-item.usecase.dart';
import 'package:le_spawn_fr/features/collections/2_domain/usecase/get-my-collections.usecase.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/1_data/repository/new-item.repository-impl.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/1_data/source/new-item-api.service.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/2_domain/repository/new-item.repository.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/2_domain/usecase/add-barcode-to-game.usecase.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/2_domain/usecase/add-game-item-to-collection.usecase.dart';

class CollectionsModule {
  static void init(GetIt sl) {
    // Services
    sl.registerSingleton<CollectionsApiService>(CollectionsApiServiceImpl());
    sl.registerSingleton<NewItemApiService>(NewItemApiServiceImpl());

    // Repositories
    sl.registerSingleton<CollectionsRepository>(CollectionsRepositoryImpl());
    sl.registerSingleton<NewItemRepository>(NewItemRepositoryImpl());

    // Usecases
    sl.registerSingleton<GetMyCollectionsUsecase>(GetMyCollectionsUsecase());
    sl.registerSingleton<AddGameItemToCollectionUsecase>(AddGameItemToCollectionUsecase());
    sl.registerSingleton<AddBarcodeToGameUsecase>(AddBarcodeToGameUsecase());
    sl.registerSingleton<DeleteGameItemUsecase>(DeleteGameItemUsecase());
  }
}
