import 'dart:convert';

class RegionEntity {
  final String id;
  final String name;
  final String abbreviation;

  RegionEntity({
    required this.id,
    required this.name,
    required this.abbreviation,
  });

  String toJson() {
    return jsonEncode({
      'id': id,
      'name': name,
      'abbreviation': abbreviation,
    });
  }
}
