import 'package:get_it/get_it.dart';
import 'package:le_spawn_fr/features/auth/1_data/repository/auth.repository-impl.dart';
import 'package:le_spawn_fr/features/auth/1_data/source/auth-api.service.dart';
import 'package:le_spawn_fr/features/auth/1_data/source/auth-local.service.dart';
import 'package:le_spawn_fr/features/auth/2_domain/repository/auth.repository.dart';
import 'package:le_spawn_fr/features/auth/2_domain/usecase/is-logged-in.usercase.dart';
import 'package:le_spawn_fr/features/auth/2_domain/usecase/login-with-google.usecase.dart';
import 'package:le_spawn_fr/features/auth/2_domain/usecase/login.usecase.dart';
import 'package:le_spawn_fr/features/auth/2_domain/usecase/logout.usecase.dart';
import 'package:le_spawn_fr/features/auth/2_domain/usecase/register.usecase.dart';

class AuthModule {
  static void init(GetIt sl) {
    // Services
    sl.registerSingleton<AuthApiService>(AuthApiServiceImpl());
    sl.registerSingleton<AuthLocalService>(AuthLocalServiceImpl());

    // Repository
    sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());

    // Usecases
    sl.registerSingleton<RegisterUsecase>(RegisterUsecase());
    sl.registerSingleton<IsLoggedInUsecase>(IsLoggedInUsecase());
    sl.registerSingleton<LogoutUsecase>(LogoutUsecase());
    sl.registerSingleton<LoginUsecase>(LoginUsecase());
    sl.registerSingleton<LoginWithGoogleUsecase>(LoginWithGoogleUsecase());
  }
}
