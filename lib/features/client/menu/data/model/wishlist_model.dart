class FavoritesResponseModel {
  final bool? success;
  final String? message;
  final FavoritesData? data;

  FavoritesResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory FavoritesResponseModel.fromJson(Map<String, dynamic> json) {
    return FavoritesResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? FavoritesData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class FavoritesData {
  final List<FavoriteProductModel>? products;
  final List<FavoriteAccountModel>? accounts;

  FavoritesData({
    this.products,
    this.accounts,
  });

  factory FavoritesData.fromJson(Map<String, dynamic> json) {
    return FavoritesData(
      products: json['products'] != null
          ? (json['products'] as List<dynamic>)
              .map((e) =>
                  FavoriteProductModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      accounts: json['accounts'] != null
          ? (json['accounts'] as List<dynamic>)
              .map((e) =>
                  FavoriteAccountModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'products': products?.map((e) => e.toJson()).toList(),
      'accounts': accounts?.map((e) => e.toJson()).toList(),
    };
  }
}

class FavoriteProductModel {
  final int? id;
  final String? name;
  final String? price;
  final String? image;
  final FavoriteAccountModel? account;

  FavoriteProductModel({
    this.id,
    this.name,
    this.price,
    this.image,
    this.account,
  });

  factory FavoriteProductModel.fromJson(Map<String, dynamic> json) {
    return FavoriteProductModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      price: json['price'] as String?,
      image: json['image'] as String?,
      account: json['account'] != null
          ? FavoriteAccountModel.fromJson(
              json['account'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'account': account?.toJson(),
    };
  }
}

class FavoriteAccountModel {
  final String? logo;
  final int? id;
  final String? cover;
  final String? name;
  final bool? verified;

  FavoriteAccountModel({
    this.logo,
    this.id,
    this.cover,
    this.name,
    this.verified,
  });

  factory FavoriteAccountModel.fromJson(Map<String, dynamic> json) {
    return FavoriteAccountModel(
      logo: json['logo'] as String?,
      id: json['id'] as int?,
      cover: json['cover'] as String?,
      name: json['name'] as String?,
      verified: json['verified'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'logo': logo,
      'cover': cover,
      'id': id,
      'name': name,
      'verified': verified,
    };
  }
}
