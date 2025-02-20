import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/features/auth/1_data/dto/login.request.dart';
import 'package:le_spawn_fr/features/auth/1_data/dto/register.request.dart';
import 'package:le_spawn_fr/features/auth/1_data/repository/auth.repository-impl.dart';

abstract class AuthRepository {
  Future<bool> isLoggedIn();

  Future<Either<String, AuthenticatedDataResponse>> register(RegisterRequest registerRequest);

  Future<Either<String, AuthenticatedDataResponse>> login(LoginRequest loginRequest);

  Future<Either<String, void>> logout();

  Future<Either<String, AuthenticatedDataResponse>> refresh();

  Future<Either<String, AuthenticatedDataResponse>> loginWithGoogle();
}
