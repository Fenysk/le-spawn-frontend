import 'package:get_it/get_it.dart';
import 'package:le_spawn_fr/features/bank/features/games/1_data/repository/games.repository-impl.dart';
import 'package:le_spawn_fr/features/bank/features/games/1_data/source/games-api.service.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/repository/games.repository.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/usecase/seach-games-from-barcode.usecase.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/usecase/search-games-in-bank.usecase.dart';
import 'package:le_spawn_fr/features/bank/features/games/2_domain/usecase/search-games-in-provider.usecase.dart';

class GamesModule {
  static void init(GetIt sl) {
    // Services
    sl.registerSingleton<GamesApiService>(GamesApiServiceImpl());

    // Repository
    sl.registerSingleton<GamesRepository>(GamesRepositoryImpl());

    // Usecases
    sl.registerSingleton<SearchGamesInBankUsecase>(SearchGamesInBankUsecase());
    sl.registerSingleton<SearchGamesInProvidersUsecase>(SearchGamesInProvidersUsecase());
    sl.registerSingleton<SearchGamesFromBarcodeUsecase>(SearchGamesFromBarcodeUsecase());
  }
}
