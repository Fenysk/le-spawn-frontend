import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/core/usecase/usecase.dart';
import 'package:le_spawn_fr/features/user/2_domain/repository/users.repository.dart';
import 'package:le_spawn_fr/service-locator.dart';

class GetUserProfileUsecase implements Usecase<Either, String> {
  @override
  Future<Either> execute({
    String? request,
  }) async {
    return serviceLocator<UsersRepository>().getUserProfile(request!);
  }
}
