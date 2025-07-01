class AddProductModel {
  bool? success;
  String? message;
  Data? data;

  AddProductModel({this.success, this.message, this.data});

  AddProductModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
}
}

class Data {
  String? accountId;
  String? name;
  String? description;
  String? price;
  String? categoryId;
  String? isSale;
  int? code;
  String? discountType;
  String? discountValue;
  String? updatedAt;
  String? createdAt;
  Details? details;
  int? id;

  Data(
      {this.accountId,
      this.name,
      this.description,
      this.price,
      this.categoryId,
      this.isSale,
      this.code,
      this.discountType,
      this.discountValue,
      this.details,
      this.updatedAt,
      this.createdAt,
      this.id});

  Data.fromJson(Map<String, dynamic> json) {
    accountId = json['account_id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    categoryId = json['category_id'];
    isSale = json['is_sale'];
    code = json['code'];
    discountType = json['discount_type'];
    discountValue = json['discount_value'];
    details = Details.fromJson(json['details']);
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['account_id'] = accountId;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['category_id'] = categoryId;
    data['is_sale'] = isSale;
    data['code'] = code;
    data['discount_type'] = discountType;
    data['discount_value'] = discountValue;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}


class ProductResponse {
  final bool success;
  final String message;
  final List<Product> data;

  ProductResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      success: json['success'],
      message: json['message'],
      data: List<Product>.from(json['data'].map((x) => Product.fromJson(x))),
    );
  }
}
class Product {
  final int id;
  final String name;
  final String description;
  final ProductDetails details;
  final String code;
  final String category;
  final String price;
  final int vendorId;
  final String vendorName;
  final bool isSale;
  final String discountType;
  final String discountValue;
  final List<Variation> variations;
  final bool isLiked;
  final int likes;
  final String image;
  final List<ProductImage> images;
  final String createdAt;
  final String updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.details,
    required this.code,
    required this.category,
    required this.price,
    required this.vendorId,
    required this.vendorName,
    required this.isSale,
    required this.discountType,
    required this.discountValue,
    required this.variations,
    required this.isLiked,
    required this.likes,
    required this.image,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      details: ProductDetails.fromJson(json['details']),
      code: json['code'],
      category: json['category'],
      price: json['price'],
      vendorId: json['vendor_id'],
      vendorName: json['vendor_name'],
      isSale: json['is_sale'] == 1,
      discountType: json['discount_type'],
      discountValue: json['discount_value'],
      variations: List<Variation>.from(
          json['variations'].map((x) => Variation.fromJson(x))),
      isLiked: json['is_liked'],
      likes: json['likes'],
      image: json['image'],
      images: List<ProductImage>.from(
          json['images'].map((x) => ProductImage.fromJson(x))),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
class ProductDetails {
  final String quality;
  final String material;

  ProductDetails({
    required this.quality,
    required this.material,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    return ProductDetails(
      quality: json['quality'],
      material: json['material'],
    );
  }
}
class Variation {
  final String name;
  final int stock;
  final String price;
  final AttributeValue attributeValue;
  final ColorModel color;

  Variation({
    required this.name,
    required this.stock,
    required this.price,
    required this.attributeValue,
    required this.color,
  });

  factory Variation.fromJson(Map<String, dynamic> json) {
    return Variation(
      name: json['name'],
      stock: json['stock'],
      price: json['price'],
      attributeValue: AttributeValue.fromJson(json['attribute_value']),
      color: ColorModel.fromJson(json['color']),
    );
  }
}
class AttributeValue {
  final int id;
  final String name;
  final String attribute;

  AttributeValue({
    required this.id,
    required this.name,
    required this.attribute,
  });

  factory AttributeValue.fromJson(Map<String, dynamic> json) {
    return AttributeValue(
      id: json['id'],
      name: json['name'],
      attribute: json['attribute'],
    );
  }
}

class ColorModel {
  final int id;
  final String name;
  final String code;

  ColorModel({
    required this.id,
    required this.name,
    required this.code,
  });

  factory ColorModel.fromJson(Map<String, dynamic> json) {
    return ColorModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
    );
  }
}
class ProductImage {
  final String url;

  ProductImage({required this.url});

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      url: json['url'],
    );
  }
}

class Details {
  final String? quality;
  final String? material;

  Details({this.quality, this.material});

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      quality: json['quality'],
      material: json['material'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quality': quality,
      'material': material,
    };
  }
}
class UpdateProductResponse {
  final bool success;
  final String message;
  final ProductData data;

  UpdateProductResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UpdateProductResponse.fromJson(Map<String, dynamic> json) {
    return UpdateProductResponse(
      success: json['success'],
      message: json['message'],
      data: ProductData.fromJson(json['data']),
    );
  }
}

class ProductData {
  final int id;
  final String? name;
  final String? description;
  final String? details;
  final String? code;
  final String? category;
  final String? price;
  final int? vendorId;
  final String? vendorName;
  final int? isSale;
  final int? active;
  final String? discountType;
  final String? discountValue;
  final String? estimatedDeliveryTime;
  final String? freeShippingCostAfter;
  final List<Variation>? variations;
  final bool? isLiked;
  final int? likes;
  final bool? isFavourited;
  final int? favourites;
  final String? image;
  final List<ProductImage>? images;
  final String? createdAt;
  final String? updatedAt;
  final String? accountType;
  final String? whatsappNumber;

  ProductData({
    required this.id,
    required this.name,
    required this.description,
    required this.details,
    required this.code,
    required this.category,
    required this.price,
    required this.vendorId,
    required this.vendorName,
    required this.isSale,
    required this.active,
    required this.discountType,
    required this.discountValue,
    required this.estimatedDeliveryTime,
    required this.freeShippingCostAfter,
    required this.variations,
    required this.isLiked,
    required this.likes,
    required this.isFavourited,
    required this.favourites,
    required this.image,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
    required this.accountType,
    required this.whatsappNumber,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      details: json['details'],
      code: json['code'],
      category: json['category'],
      price: json['price'],
      vendorId: json['vendor_id'],
      vendorName: json['vendor_name'],
      isSale: json['is_sale'],
      active: json['active'],
      discountType: json['discount_type'],
      discountValue: json['discount_value'],
      estimatedDeliveryTime: json['estimated_delivery_time'],
      freeShippingCostAfter: json['free_shipping_cost_after'],
      variations: (json['variations'] as List)
          .map((v) => Variation.fromJson(v))
          .toList(),
      isLiked: json['is_liked'],
      likes: json['likes'],
      isFavourited: json['is_favourited'],
      favourites: json['favourites'],
      image: json['image'],
      images: (json['images'] as List)
          .map((img) => ProductImage.fromJson(img))
          .toList(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      accountType: json['account_type'],
      whatsappNumber: json['whatsapp_number'],
    );
  }
}
