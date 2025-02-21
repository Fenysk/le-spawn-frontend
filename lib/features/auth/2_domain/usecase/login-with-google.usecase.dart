import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/core/usecase/usecase.dart';
import 'package:le_spawn_fr/features/auth/1_data/repository/auth.repository-impl.dart';
import 'package:le_spawn_fr/features/auth/2_domain/repository/auth.repository.dart';
import 'package:le_spawn_fr/core/di/service-locator.dart';

class LoginWithGoogleUsecase implements Usecase<Either<String, AuthenticatedDataResponse>, void> {
  @override
  Future<Either<String, AuthenticatedDataResponse>> execute({
    void request,
  }) async {
    return serviceLocator<AuthRepository>().loginWithGoogle();
  }
}
