import 'package:equatable/equatable.dart';

class LocationModel extends Equatable {
  final int id;
  final String name;
  final int? countryId;
  final int? stateId;

  const LocationModel({
    required this.id,
    required this.name,
    this.countryId,
    this.stateId,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as int,
      name: json['name'] as String,
      countryId: json['country_id'] as int?,
      stateId: json['state_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (countryId != null) 'country_id': countryId,
      if (stateId != null) 'state_id': stateId,
    };
  }

  @override
  List<Object?> get props => [id, name, countryId, stateId];
}
