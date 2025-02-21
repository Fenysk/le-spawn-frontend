import 'package:get_it/get_it.dart';
import 'package:le_spawn_fr/features/reports/1_data/repository/reports.repository-impl.dart';
import 'package:le_spawn_fr/features/reports/1_data/source/reports-api.service.dart';
import 'package:le_spawn_fr/features/reports/2_domain/repository/reports.repository.dart';
import 'package:le_spawn_fr/features/reports/3_presentation/bloc/report-game.cubit.dart';

class ReportsModule {
  static void init(GetIt sl) {
    // Services
    sl.registerSingleton<ReportsApiService>(ReportsApiServiceImpl());

    // Repository
    sl.registerSingleton<ReportsRepository>(ReportsRepositoryImpl());

    // Cubits
    sl.registerFactory<ReportGameCubit>(() => ReportGameCubit());
  }
}
