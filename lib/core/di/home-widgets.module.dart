import 'package:get_it/get_it.dart';
import 'package:le_spawn_fr/features/home-widgets/1_data/source/game-counter-widget.service.dart';

class HomeWidgetsModule {
  static void init(GetIt sl) {
    // Services
    sl.registerSingleton<GameCounterWidgetService>(GameCounterWidgetService());
  }
}
