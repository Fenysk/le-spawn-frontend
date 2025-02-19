import 'package:dartz/dartz.dart';
import 'package:le_spawn_fr/features/auth/1_data/dto/login.request.dart';
import 'package:le_spawn_fr/features/auth/1_data/dto/register.request.dart';
import 'package:le_spawn_fr/features/user/2_domain/entity/user.entity.dart';

abstract class AuthRepository {
  Future<bool> isLoggedIn();

  Future<Either> register(RegisterRequest registerRequest);

  Future<Either<String, UserEntity>> login(LoginRequest loginRequest);

  Future<Either> logout();

  Future<Either> refresh();

  Future<Either<String, UserEntity>> loginWithGoogle();
}
