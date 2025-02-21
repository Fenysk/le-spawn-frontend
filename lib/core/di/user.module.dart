import 'package:get_it/get_it.dart';
import 'package:le_spawn_fr/features/user/1_data/repository/users.repository-impl.dart';
import 'package:le_spawn_fr/features/user/1_data/source/user-local.service.dart';
import 'package:le_spawn_fr/features/user/1_data/source/users-api.service.dart';
import 'package:le_spawn_fr/features/user/2_domain/repository/users.repository.dart';
import 'package:le_spawn_fr/features/user/2_domain/usecase/get-my-profile.usecase.dart';
import 'package:le_spawn_fr/features/user/2_domain/usecase/get-user-profile.usecase.dart';
import 'package:le_spawn_fr/features/user/2_domain/usecase/load-my-user-profile.usecase.dart';

class UserModule {
  static void init(GetIt sl) {
    // Services
    sl.registerSingleton<UsersApiService>(UsersApiServiceImpl());
    sl.registerSingleton<UserLocalService>(UserLocalServiceImpl());

    // Repository
    sl.registerSingleton<UsersRepository>(UsersRepositoryImpl());

    // Usecases
    sl.registerSingleton<GetMyProfileUsecase>(GetMyProfileUsecase());
    sl.registerSingleton<GetUserProfileUsecase>(GetUserProfileUsecase());
    sl.registerSingleton<LoadMyUserProfileUsecase>(LoadMyUserProfileUsecase());
  }
}
