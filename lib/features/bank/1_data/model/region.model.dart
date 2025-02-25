import 'dart:convert';
import 'package:le_spawn_fr/features/bank/2_domain/entity/region.entity.dart';

class RegionModel {
  final String id;
  final String name;
  final String abbreviation;

  RegionModel({
    required this.id,
    required this.name,
    required this.abbreviation,
  });

  String toJson() => json.encode({
        'id': id,
        'name': name,
        'abbreviation': abbreviation,
      });

  factory RegionModel.fromMap(Map<String, dynamic> map) {
    return RegionModel(
      id: map['id'],
      name: map['name'],
      abbreviation: map['abbreviation'],
    );
  }

  factory RegionModel.fromJson(String source) => RegionModel.fromMap(json.decode(source));

  RegionEntity toEntity() => RegionEntity(
        id: id,
        name: name,
        abbreviation: abbreviation,
      );
}
