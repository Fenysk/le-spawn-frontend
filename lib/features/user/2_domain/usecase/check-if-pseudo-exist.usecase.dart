import 'package:dartz/dartz.dart';
import 'package:le_spawn_frontend/features/user/2_domain/repository/users.repository.dart';
import 'package:le_spawn_frontend/core/usecase/usecase.dart';
import 'package:le_spawn_frontend/service-locator.dart';

class CheckIfPseudoExistUsecase implements Usecase<Either, dynamic> {
  @override
  Future<Either> execute({
    dynamic request,
  }) async {
    return serviceLocator<UsersRepository>().checkIfPseudoExist(request);
  }
}
