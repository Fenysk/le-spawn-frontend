import 'package:get_it/get_it.dart';
import 'package:le_spawn_frontend/core/network/dio_client.dart';
import 'package:le_spawn_frontend/features/auth/1_data/repository/auth.repository-impl.dart';
import 'package:le_spawn_frontend/features/auth/1_data/source/auth-api.service.dart';
import 'package:le_spawn_frontend/features/auth/1_data/source/auth-local.service.dart';
import 'package:le_spawn_frontend/features/auth/2_domain/repository/auth.repository.dart';
import 'package:le_spawn_frontend/features/auth/2_domain/usecase/is-logged-in.usercase.dart';
import 'package:le_spawn_frontend/features/auth/2_domain/usecase/login.usecase.dart';
import 'package:le_spawn_frontend/features/auth/2_domain/usecase/logout.usecase.dart';
import 'package:le_spawn_frontend/features/auth/2_domain/usecase/register.usecase.dart';
import 'package:le_spawn_frontend/features/collections/1_data/repository/collections.repository-impl.dart';
import 'package:le_spawn_frontend/features/collections/1_data/source/collections-api.service.dart';
import 'package:le_spawn_frontend/features/collections/2_domain/repository/collections.repository.dart';
import 'package:le_spawn_frontend/features/collections/2_domain/usecase/get-my-collections.usecase.dart';
import 'package:le_spawn_frontend/features/user/1_data/repository/users.repository-impl.dart';
import 'package:le_spawn_frontend/features/user/1_data/source/user-local.service.dart';
import 'package:le_spawn_frontend/features/user/1_data/source/users-api.service.dart';
import 'package:le_spawn_frontend/features/user/2_domain/repository/users.repository.dart';
import 'package:le_spawn_frontend/features/user/2_domain/usecase/get-my-profile.usecase.dart';
import 'package:le_spawn_frontend/features/user/2_domain/usecase/get-user-profile.usecase.dart';
import 'package:le_spawn_frontend/features/user/2_domain/usecase/load-my-user-profile.usecase.dart';

final serviceLocator = GetIt.instance;

void setupServiceLocator() {
  //// Network
  serviceLocator.registerSingleton<DioClient>(DioClient());

  //// Services
  serviceLocator.registerSingleton<AuthApiService>(AuthApiServiceImpl());
  serviceLocator.registerSingleton<AuthLocalService>(AuthLocalServiceImpl());
  serviceLocator.registerSingleton<UsersApiService>(UsersApiServiceImpl());
  serviceLocator.registerSingleton<UserLocalService>(UserLocalServiceImpl());
  serviceLocator.registerSingleton<CollectionsApiService>(CollectionsApiServiceImpl());

  //// Repositories
  serviceLocator.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  serviceLocator.registerSingleton<UsersRepository>(UsersRepositoryImpl());
  serviceLocator.registerSingleton<CollectionsRepository>(CollectionsRepositoryImpl());

  //// Usecases
  serviceLocator.registerSingleton<RegisterUsecase>(RegisterUsecase());
  serviceLocator.registerSingleton<IsLoggedInUsecase>(IsLoggedInUsecase());
  serviceLocator.registerSingleton<GetMyProfileUsecase>(GetMyProfileUsecase());
  serviceLocator.registerSingleton<GetUserProfileUsecase>(GetUserProfileUsecase());
  serviceLocator.registerSingleton<LoadMyUserProfileUsecase>(LoadMyUserProfileUsecase());
  serviceLocator.registerSingleton<LogoutUsecase>(LogoutUsecase());
  serviceLocator.registerSingleton<LoginUsecase>(LoginUsecase());
  serviceLocator.registerSingleton<GetMyCollectionsUsecase>(GetMyCollectionsUsecase());
}
