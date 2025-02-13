import 'package:dartz/dartz.dart';
import 'package:le_spawn_frontend/core/usecase/usecase.dart';
import 'package:le_spawn_frontend/features/auth/2_domain/repository/auth.repository.dart';
import 'package:le_spawn_frontend/service-locator.dart';

class LogoutUsecase implements Usecase<Either, dynamic> {
  @override
  Future<Either> execute({
    dynamic request,
  }) async {
    return serviceLocator<AuthRepository>().logout();
  }
}
