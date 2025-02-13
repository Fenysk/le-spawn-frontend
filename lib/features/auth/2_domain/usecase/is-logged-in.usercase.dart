import 'package:le_spawn_frontend/core/usecase/usecase.dart';
import 'package:le_spawn_frontend/features/auth/2_domain/repository/auth.repository.dart';
import 'package:le_spawn_frontend/service-locator.dart';

class IsLoggedInUsecase implements Usecase<bool, dynamic> {
  @override
  Future<bool> execute({
    dynamic request,
  }) async {
    return serviceLocator<AuthRepository>().isLoggedIn();
  }
}
