class PackagesResponse {
  final bool success;
  final String message;
  final List<PackageModel> data;

  PackagesResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PackagesResponse.fromJson(Map<String, dynamic> json) {
    return PackagesResponse(
      success: json['success'],
      message: json['message'],
      data: List<PackageModel>.from(
        json['data'].map((x) => PackageModel.fromJson(x)),
      ),
    );
  }
}

class PackageModel {
  final int id;
  final String name;
  final String price;
  final int maxProducts;
  final int durationDays;
  final Map<String, String> features;

  PackageModel({
    required this.id,
    required this.name,
    required this.price,
    required this.maxProducts,
    required this.durationDays,
    required this.features,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      maxProducts: json['max_products'],
      durationDays: json['duration_days'],
      features: Map<String, String>.from(json['features']),
    );
  }
}
