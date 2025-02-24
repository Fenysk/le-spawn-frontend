import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/core/usecase/usecase.dart';
import 'package:le_spawn_fr/features/app/2_domain/repository/update-checker.repository.dart';
import 'package:le_spawn_fr/core/di/service-locator.dart';

class CheckUpdateUseCase implements Usecase<Either<String, void>, String> {
  @override
  Future<Either<String, void>> execute({String? request}) async {
    return serviceLocator<UpdateCheckerRepository>().checkForUpdate(request!);
  }
}
