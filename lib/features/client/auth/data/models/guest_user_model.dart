class GuestUserModel {
  final String id;
  GuestUserModel({required this.id});
  factory GuestUserModel.fromJson(Map<String, dynamic> json) {
    return GuestUserModel(
      id: json['id'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
      };
}