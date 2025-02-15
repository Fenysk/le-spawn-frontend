import 'dart:convert';
import 'package:le_spawn_fr/core/enums/role.enum.dart';
import 'package:le_spawn_fr/features/collections/1_data/model/collection.model.dart';
import 'package:le_spawn_fr/features/user/1_data/model/profile.model.dart';
import 'package:le_spawn_fr/features/user/2_domain/entity/user.entity.dart';

class UserModel {
  final String id;
  final String? email;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Role> roles;
  final ProfileModel? profile;
  final List<CollectionModel> collections;

  UserModel({
    required this.id,
    this.email,
    required this.createdAt,
    required this.updatedAt,
    required this.roles,
    this.profile,
    required this.collections,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'roles': roles.map((role) => role.toString().split('.').last.toLowerCase()).toList(),
      'profile': profile?.toMap(),
      'collections': collections.map((collection) => collection.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      roles: List<Role>.from(map['roles']?.map((x) => Role.values.firstWhere((e) => e.toString().split('.').last.toLowerCase() == x)) ?? []),
      profile: map['profile'] != null ? ProfileModel.fromMap(map['profile']) : null,
      collections: List<CollectionModel>.from(map['collections']?.map((x) => CollectionModel.fromMap(x)) ?? []),
    );
  }
}

extension UserModelExtension on UserModel {
  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        createdAt: createdAt,
        updatedAt: updatedAt,
        roles: roles,
        profile: profile?.toEntity(),
      );
}
