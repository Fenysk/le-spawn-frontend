import 'dart:convert';

import 'package:le_spawn_frontend/features/user/2_domain/entity/profile.entity.dart';

class ProfileModel {
  final String? pseudo;
  final String? displayName;
  final String? biography;
  final String? link;
  final String? avatarUrl;
  final String userId;

  ProfileModel({
    this.pseudo,
    this.displayName,
    this.biography,
    this.link,
    this.avatarUrl,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'pseudo': pseudo,
      'displayName': displayName,
      'biography': biography,
      'link': link,
      'avatarUrl': avatarUrl,
      'userId': userId,
    };
  }

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) => ProfileModel.fromMap(json.decode(source));

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      pseudo: map['pseudo'],
      displayName: map['displayName'],
      biography: map['biography'],
      link: map['link'],
      avatarUrl: map['avatarUrl'],
      userId: map['userId'],
    );
  }
}

extension ProfileModelExtension on ProfileModel {
  ProfileEntity toEntity() => ProfileEntity(
        pseudo: pseudo,
        displayName: displayName,
        biography: biography,
        link: link,
        avatarUrl: avatarUrl,
        userId: userId,
      );
}