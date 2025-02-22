import 'package:get_it/get_it.dart';
import 'package:le_spawn_fr/core/di/auth.module.dart';
import 'package:le_spawn_fr/core/di/collections.module.dart';
import 'package:le_spawn_fr/core/di/core.module.dart';
import 'package:le_spawn_fr/core/di/games.module.dart';
import 'package:le_spawn_fr/core/di/reports.module.dart';
import 'package:le_spawn_fr/core/di/storage.module.dart';
import 'package:le_spawn_fr/core/di/user.module.dart';

final serviceLocator = GetIt.instance;

void setupServiceLocator() {
  CoreModule.init(serviceLocator);

  AuthModule.init(serviceLocator);
  UserModule.init(serviceLocator);
  CollectionsModule.init(serviceLocator);
  GamesModule.init(serviceLocator);
  ReportsModule.init(serviceLocator);
  StorageModule.init(serviceLocator);
}
