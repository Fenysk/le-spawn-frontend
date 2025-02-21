import 'package:get_it/get_it.dart';
import 'package:le_spawn_fr/core/network/dio_client.dart';

class CoreModule {
  static void init(GetIt sl) {
    // Network
    sl.registerSingleton<DioClient>(DioClient());
  }
}
