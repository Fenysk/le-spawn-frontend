import 'package:le_spawn_fr/core/enums/role.enum.dart';
import 'package:le_spawn_fr/features/user/2_domain/entity/profile.entity.dart';

class UserEntity {
  final String id;
  final String? email;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Role> roles;
  final ProfileEntity? profile;

  UserEntity({
    required this.id,
    this.email,
    required this.createdAt,
    required this.updatedAt,
    required this.roles,
    this.profile,
  });

  UserEntity copyWith({
    String? id,
    String? email,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Role>? roles,
    ProfileEntity? profile,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      roles: roles ?? this.roles,
      profile: profile ?? this.profile,
    );
  }
}
