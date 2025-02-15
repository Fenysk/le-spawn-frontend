import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/core/usecase/usecase.dart';
import 'package:le_spawn_fr/features/user/2_domain/repository/users.repository.dart';
import 'package:le_spawn_fr/service-locator.dart';

class GetMyProfileUsecase implements Usecase<Either, dynamic> {
  @override
  Future<Either> execute({
    dynamic request,
  }) async {
    return serviceLocator<UsersRepository>().getMyProfile();
  }
}
