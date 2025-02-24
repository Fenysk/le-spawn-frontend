import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/features/app/2_domain/repository/update-checker.repository.dart';
import 'package:le_spawn_fr/core/di/service-locator.dart';
import '../source/update-checker-api.service.dart';

class UpdateCheckerRepositoryImpl implements UpdateCheckerRepository {
  @override
  Future<Either<String, void>> checkForUpdate(String currentVersion) async {
    Either<String, void> response = await serviceLocator<UpdateCheckerApiService>().checkForUpdate(currentVersion);

    return response.fold(
      (error) => Left(error),
      (_) => Right(null),
    );
  }
}
