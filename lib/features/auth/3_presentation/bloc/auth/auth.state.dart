import 'package:equatable/equatable.dart';
import 'package:le_spawn_fr/features/user/2_domain/entity/user.entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthLoadingState extends AuthState {}

class AuthenticatedState extends AuthState {
  final UserEntity? user;

  const AuthenticatedState({this.user});

  @override
  List<Object?> get props => [
        user,
      ];
}

class UnauthenticatedState extends AuthState {
  final String? errorMessage;

  const UnauthenticatedState({this.errorMessage});

  @override
  List<Object?> get props => [
        errorMessage
      ];
}
