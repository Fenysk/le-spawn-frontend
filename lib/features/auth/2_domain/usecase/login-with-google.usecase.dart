import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/core/usecase/usecase.dart';
import 'package:le_spawn_fr/features/auth/2_domain/repository/auth.repository.dart';
import 'package:le_spawn_fr/features/user/2_domain/entity/user.entity.dart';
import 'package:le_spawn_fr/service-locator.dart';

class LoginWithGoogleUsecase implements Usecase<Either<String, UserEntity>, void> {
  @override
  Future<Either<String, UserEntity>> execute({
    void request,
  }) async {
    return serviceLocator<AuthRepository>().loginWithGoogle();
  }
}
