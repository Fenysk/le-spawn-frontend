import 'package:dartz/dartz.dart';
import 'package:le_spawn_frontend/core/usecase/usecase.dart';
import 'package:le_spawn_frontend/features/auth/1_data/dto/register.request.dart';
import 'package:le_spawn_frontend/features/auth/2_domain/repository/auth.repository.dart';
import 'package:le_spawn_frontend/service-locator.dart';

class RegisterUsecase implements Usecase<Either, RegisterRequest> {
  @override
  Future<Either> execute({
    RegisterRequest? request,
  }) async {
    return serviceLocator<AuthRepository>().register(request!);
  }
}
