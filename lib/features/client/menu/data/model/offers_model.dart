class OfferModel {
  final bool success;
  final String message;
  final OfferData? data; // Make data nullable

  OfferModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      success: json['success'] as bool? ?? false, // Default to false if null
      message:
          json['message'] as String? ?? '', // Default to empty string if null
      data: json['data'] != null
          ? OfferData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class OfferData {
  final List<Offer>? offers; // Make offers nullable
  final int currentPage;
  final int lastPage;
  final int total;

  OfferData({
    this.offers,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  factory OfferData.fromJson(Map<String, dynamic> json) {
    return OfferData(
      offers: (json['offers'] as List?)
              ?.map((item) => Offer.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      currentPage: json['current_page'] as int? ?? 0,
      lastPage: json['last_page'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
    );
  }
}

class Offer {
  final int id;
  final String originalPrice;
  final String offerPrice;
  final String status;
  final String message;
  final String createdAt;
  final String updatedAt;
  final String expiresAt;
  final User user;
  final Account account;
  final String offerableType;
  final int offerableId;
  final Offerable? offerable; // Make offerable nullable

  Offer({
    required this.id,
    required this.originalPrice,
    required this.offerPrice,
    required this.status,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    required this.expiresAt,
    required this.user,
    required this.account,
    required this.offerableType,
    required this.offerableId,
    this.offerable,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      id: json['id'] as int,
      originalPrice: json['original_price'] as String? ?? '',
      offerPrice: json['offer_price'] as String? ?? '',
      status: json['status'] as String? ?? '',
      message: json['message'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      expiresAt: json['expires_at'] as String? ?? '',
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      account: Account.fromJson(json['account'] as Map<String, dynamic>),
      offerableType: json['offerable_type'] as String? ?? '',
      offerableId: json['offerable_id'] as int? ?? 0,
      offerable: json['offerable'] != null
          ? Offerable.fromJson(json['offerable'] as Map<String, dynamic>)
          : null,
    );
  }
}

// Keep User, Account, and Offerable classes as they are, but ensure they handle nulls where applicable
class User {
  final int id;
  final String firstName;
  final String lastName;
  final String image;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int? ?? 0,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }
}

class Account {
  final int id;
  final String name;
  final String logo;

  Account({
    required this.id,
    required this.name,
    required this.logo,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      logo: json['logo'] as String? ?? '',
    );
  }
}

class Offerable {
  final int id;
  final String name;
  final String price;
  final String image;

  Offerable({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });

  factory Offerable.fromJson(Map<String, dynamic> json) {
    return Offerable(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      price: json['price'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );
  }
}
