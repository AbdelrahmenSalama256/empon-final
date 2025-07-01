// model/package_ads_response.dart
class PackageAdsResponse {
  final bool success;
  final String message;
  final PackageAdsData data;

  PackageAdsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PackageAdsResponse.fromJson(Map<String, dynamic> json) =>
      PackageAdsResponse(
        success: json['success'],
        message: json['message'],
        data: PackageAdsData.fromJson(json['data']),
      );
}

class PackageAdsData {
  final UserPackage userPackage;
  final int adsCount;
  final List<Ad> ads;

  PackageAdsData({
    required this.userPackage,
    required this.adsCount,
    required this.ads,
  });

  factory PackageAdsData.fromJson(Map<String, dynamic> json) => PackageAdsData(
        userPackage: UserPackage.fromJson(json['user_package']),
        adsCount: json['ads_count'],
        ads: List<Ad>.from(json['ads'].map((x) => Ad.fromJson(x))),
      );
}

class UserPackage {
  final int id;
  final int userId;
  final int packageId;
  final int accountId;
  final List<int> productIds;
  final String startsAt;
  final String endsAt;
  final String createdAt;
  final String updatedAt;
  final Package packageInfo;

  UserPackage({
    required this.id,
    required this.userId,
    required this.packageId,
    required this.accountId,
    required this.productIds,
    required this.startsAt,
    required this.endsAt,
    required this.createdAt,
    required this.updatedAt,
    required this.packageInfo,
  });

  factory UserPackage.fromJson(Map<String, dynamic> json) => UserPackage(
        id: json['id'],
        userId: json['user_id'],
        packageId: json['package_id'],
        accountId: json['account_id'],
        productIds: List<int>.from(json['product_ids']),
        startsAt: json['starts_at'],
        endsAt: json['ends_at'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        packageInfo: Package.fromJson(json['package']),
      );
}

class Package {
  final int id;
  final String name;
  final String price;
  final int durationDays;
  final int maxProducts;

  Package({
    required this.id,
    required this.name,
    required this.price,
    required this.durationDays,
    required this.maxProducts,
  });

  factory Package.fromJson(Map<String, dynamic> json) => Package(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        durationDays: json['duration_days'],
        maxProducts: json['max_products'],
      );
}

class Ad {
  final int id;
  final String title;
  final String description;
  final String genderFilter;
  final int minAge;
  final int maxAge;
  final String startDate;
  final String endDate;
  final String paymentAmount;
  final String status;
  final String createdAt;
  final String updatedAt;
  final Location city;

  Ad({
    required this.id,
    required this.title,
    required this.description,
    required this.genderFilter,
    required this.minAge,
    required this.maxAge,
    required this.startDate,
    required this.endDate,
    required this.paymentAmount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.city,
  });

  factory Ad.fromJson(Map<String, dynamic> json) => Ad(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        genderFilter: json['gender_filter'],
        minAge: json['min_age'],
        maxAge: json['max_age'],
        startDate: json['start_date'],
        endDate: json['end_date'],
        paymentAmount: json['payment_amount'],
        status: json['status'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        city: Location.fromJson(json['city']),
      );
}

class Location {
  final int id;
  final String name;

  Location({required this.id, required this.name});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json['id'],
        name: json['name'] ?? '',
      );
}
