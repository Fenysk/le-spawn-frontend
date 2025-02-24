import 'package:get_it/get_it.dart';
import 'package:le_spawn_fr/features/storage/1_data/repository/storage.repository-impl.dart';
import 'package:le_spawn_fr/features/storage/1_data/source/storage-api.service.dart';
import 'package:le_spawn_fr/features/storage/2_domain/repository/storage.repository.dart';
import 'package:le_spawn_fr/features/storage/2_domain/usecase/delete-file.usecase.dart';
import 'package:le_spawn_fr/features/storage/2_domain/usecase/upload-file.usecase.dart';

class StorageModule {
  static void init(GetIt sl) {
    // Services
    sl.registerSingleton<StorageApiService>(StorageApiServiceImpl());

    // Repository
    sl.registerSingleton<StorageRepository>(StorageRepositoryImpl());

    // Usecases
    sl.registerSingleton<UploadFileUseCase>(UploadFileUseCase(sl()));
    sl.registerSingleton<DeleteFileUseCase>(DeleteFileUseCase(sl()));
  }
}
