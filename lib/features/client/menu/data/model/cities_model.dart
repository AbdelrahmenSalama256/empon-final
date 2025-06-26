class CitiesResponse {
  final bool success;
  final String message;
  final List<City> data;

  CitiesResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CitiesResponse.fromJson(Map<String, dynamic> json) {
    return CitiesResponse(
      success: json['success'],
      message: json['message'],
      data: List<City>.from(json['data'].map((city) => City.fromJson(city))),
    );
  }
}

class City {
  final int id;
  final int stateId;
  final String name;

  City({
    required this.id,
    required this.stateId,
    required this.name,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      stateId: json['state_id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'state_id': stateId,
      'name': name,
    };
  }
}
