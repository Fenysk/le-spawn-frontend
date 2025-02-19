import 'package:get_it/get_it.dart';
import 'package:le_spawn_fr/core/network/dio_client.dart';
import 'package:le_spawn_fr/features/auth/1_data/repository/auth.repository-impl.dart';
import 'package:le_spawn_fr/features/auth/1_data/source/auth-api.service.dart';
import 'package:le_spawn_fr/features/auth/1_data/source/auth-local.service.dart';
import 'package:le_spawn_fr/features/auth/2_domain/repository/auth.repository.dart';
import 'package:le_spawn_fr/features/auth/2_domain/usecase/is-logged-in.usercase.dart';
import 'package:le_spawn_fr/features/auth/2_domain/usecase/login-with-google.usecase.dart';
import 'package:le_spawn_fr/features/auth/2_domain/usecase/login.usecase.dart';
import 'package:le_spawn_fr/features/auth/2_domain/usecase/logout.usecase.dart';
import 'package:le_spawn_fr/features/auth/2_domain/usecase/register.usecase.dart';
import 'package:le_spawn_fr/features/bank/features/games/1_data/repository/games.repository-impl.dart';
import 'package:le_spawn_fr/features/bank/features/games/1_data/source/games-api.service.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/repository/games.repository.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/usecase/search-games-in-bank.usecase.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/usecase/search-games-in-provider.usecase.dart';
import 'package:le_spawn_fr/features/collections/1_data/repository/collections.repository-impl.dart';
import 'package:le_spawn_fr/features/collections/1_data/source/collections-api.service.dart';
import 'package:le_spawn_fr/features/collections/2_domain/repository/collections.repository.dart';
import 'package:le_spawn_fr/features/collections/2_domain/usecase/get-my-collections.usecase.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/1_data/repository/new-item.repository-impl.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/1_data/source/new-item-api.service.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/2_domain/repository/new-item.repository.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/2_domain/usecase/add-barcode-to-game.usecase.dart';
import 'package:le_spawn_fr/features/collections/features/add-new-item/2_domain/usecase/add-game-item-to-collection.usecase.dart';
import 'package:le_spawn_fr/features/user/1_data/repository/users.repository-impl.dart';
import 'package:le_spawn_fr/features/user/1_data/source/user-local.service.dart';
import 'package:le_spawn_fr/features/user/1_data/source/users-api.service.dart';
import 'package:le_spawn_fr/features/user/2_domain/repository/users.repository.dart';
import 'package:le_spawn_fr/features/user/2_domain/usecase/get-my-profile.usecase.dart';
import 'package:le_spawn_fr/features/user/2_domain/usecase/get-user-profile.usecase.dart';
import 'package:le_spawn_fr/features/user/2_domain/usecase/load-my-user-profile.usecase.dart';

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
  serviceLocator.registerSingleton<GamesApiService>(GamesApiServiceImpl());
  serviceLocator.registerSingleton<NewItemApiService>(NewItemApiServiceImpl());

  //// Repositories
  serviceLocator.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  serviceLocator.registerSingleton<UsersRepository>(UsersRepositoryImpl());
  serviceLocator.registerSingleton<CollectionsRepository>(CollectionsRepositoryImpl());
  serviceLocator.registerSingleton<GamesRepository>(GamesRepositoryImpl());
  serviceLocator.registerSingleton<NewItemRepository>(NewItemRepositoryImpl());

  //// Usecases
  serviceLocator.registerSingleton<RegisterUsecase>(RegisterUsecase());
  serviceLocator.registerSingleton<IsLoggedInUsecase>(IsLoggedInUsecase());
  serviceLocator.registerSingleton<GetMyProfileUsecase>(GetMyProfileUsecase());
  serviceLocator.registerSingleton<GetUserProfileUsecase>(GetUserProfileUsecase());
  serviceLocator.registerSingleton<LoadMyUserProfileUsecase>(LoadMyUserProfileUsecase());
  serviceLocator.registerSingleton<LogoutUsecase>(LogoutUsecase());
  serviceLocator.registerSingleton<LoginUsecase>(LoginUsecase());
  serviceLocator.registerSingleton<GetMyCollectionsUsecase>(GetMyCollectionsUsecase());
  serviceLocator.registerSingleton<SearchGamesInBankUsecase>(SearchGamesInBankUsecase());
  serviceLocator.registerSingleton<SearchGamesInProvidersUsecase>(SearchGamesInProvidersUsecase());
  serviceLocator.registerSingleton<AddGameItemToCollectionUsecase>(AddGameItemToCollectionUsecase());
  serviceLocator.registerSingleton<AddBarcodeToGameUsecase>(AddBarcodeToGameUsecase());
  serviceLocator.registerSingleton<LoginWithGoogleUsecase>(LoginWithGoogleUsecase());
}
