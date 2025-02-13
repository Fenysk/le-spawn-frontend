class ProfileEntity {
  final String userId;
  final String? pseudo;
  final String? displayName;
  final String? biography;
  final String? link;
  final String? avatarUrl;

  ProfileEntity({
    required this.userId,
    this.pseudo,
    this.displayName,
    this.biography,
    this.link,
    this.avatarUrl,
  });
}
