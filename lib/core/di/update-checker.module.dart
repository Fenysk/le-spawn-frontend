import 'package:get_it/get_it.dart';
import 'package:le_spawn_fr/features/app/1_data/source/update-checker-api.service.dart';
import 'package:le_spawn_fr/features/app/1_data/repository/update-checker.repository-impl.dart';
import 'package:le_spawn_fr/features/app/2_domain/repository/update-checker.repository.dart';
import 'package:le_spawn_fr/features/app/2_domain/usecase/check-update.usecase.dart';
import 'package:le_spawn_fr/features/app/3_presentation/bloc/update-checker.cubit.dart';

class UpdateCheckerModule {
  static void init(GetIt sl) {
    // Source
    sl.registerSingleton<UpdateCheckerApiService>(UpdateCheckerSourceImpl());

    // Repository
    sl.registerSingleton<UpdateCheckerRepository>(UpdateCheckerRepositoryImpl());

    // UseCase
    sl.registerSingleton<CheckUpdateUseCase>(CheckUpdateUseCase());

    // Cubit
    sl.registerFactory<UpdateCheckerCubit>(() => UpdateCheckerCubit());
  }
}
