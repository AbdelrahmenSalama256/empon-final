class AddressModel {
  final int id;
  final int? countryId;
  final int? stateId;
  final int? cityId;
  final String? country;
  final String? state;
  final String? city;
  final String? address;
  final String? lat;
  final String? lng;
  final String? name;

  const AddressModel({
    required this.id,
    this.countryId,
    this.stateId,
    this.cityId,
    this.country,
    this.state,
    this.city,
    this.address,
    this.lat,
    this.lng,
    this.name,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as int? ?? 0,
      countryId: json['country_id'] as int?,
      stateId: json['state_id'] as int?,
      cityId: json['city_id'] as int?,
      country: json['country'] as String?,
      state: json['state'] as String?,
      city: json['city'] as String?,
      address: json['address'] as String?,
      lat: json['lat'] as String?,
      lng: json['lng'] as String?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country_id': countryId,
      'state_id': stateId,
      'city_id': cityId,
      'country': country,
      'state': state,
      'city': city,
      'address': address,
      'lat': lat,
      'lng': lng,
      'name': name,
    };
  }

  AddressModel copyWith({
    int? id,
    int? countryId,
    int? stateId,
    int? cityId,
    String? country,
    String? state,
    String? city,
    String? address,
    String? lat,
    String? lng,
    String? name,
  }) {
    return AddressModel(
      id: id ?? this.id,
      countryId: countryId ?? this.countryId,
      stateId: stateId ?? this.stateId,
      cityId: cityId ?? this.cityId,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      address: address ?? this.address,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      name: name ?? this.name,
    );
  }
}
