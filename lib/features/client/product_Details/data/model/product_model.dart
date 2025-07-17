class ProductModel {
  final bool success;
  final String message;
  final ProductData? data;

  ProductModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? ProductData.fromJson(json['data']) : null,
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

class ProductData {
  final int? id;
  final String? name;
  final String? description;
  final String? code;
  final String? category;
  final String? price;
  final int? vendorId;
  final String? vendorName;
  final int? isSale;
  final int? commentCount;
  final bool isLiked;
  final bool isLoved;
  final String? discountType;
  final String? discountValue;
  final List<Variation>? variations;
  final int? likes;
  final String? image;
  final List<ImageData>? images;
  final String? shippingStartDate;
  final String? shippingEndDate;
  final String? shippingPrice;
  int? active;
  final String? accountType;
  final String? whastappNum;
  final List<Detail>? details;

  final String? createdAt;
  final String? updatedAt;

  ProductData(
      {this.id,
      this.name,
      this.description,
      this.isLiked = false,
      this.code,
      this.accountType,
      this.commentCount,
      this.whastappNum,
      this.category,
      this.isLoved = false,
      this.price,
      this.shippingStartDate,
      this.shippingEndDate,
      this.shippingPrice,
      this.vendorId,
      this.vendorName,
      this.isSale,
      this.discountType,
      this.discountValue,
      this.variations,
      this.likes,
      this.image,
      this.images,
      this.details, // Added details parameter
      this.createdAt,
      this.updatedAt,
      this.active});

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        code: json['code'],
        accountType: json['account_type'],
        whastappNum: json['whatsapp_number'],
        category: json['category'],
        price: json['price'],
        vendorId: json['vendor_id'],
        vendorName: json['vendor_name'],
        isLoved: json['is_favourited'] ?? false,
        isLiked: json['is_liked'] ?? false,
        isSale: json['is_sale'],
        discountType: json['discount_type'],
        discountValue: json['discount_value'],
        variations: (json['variations'] as List?)
            ?.map((item) => Variation.fromJson(item))
            .toList(),
        likes: json['likes'],
        image: json['image'],
        images: (json['images'] as List?)
            ?.map((item) => ImageData.fromJson(item))
            .toList(),
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        commentCount: json['comments_count'] as int?,
        shippingStartDate: json['shipping_start_date'],
        shippingEndDate: json['shipping_end_date'],
        shippingPrice: json['shipping_price'],
  details: (json['details'] is List)
            ? (json['details'] as List)
                .map((item) => Detail.fromJson(item))
                .toList()
            : null, // Assign parsed details as List<Detail>
        active: json['active']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'code': code,
      'category': category,
      'is_liked': isLiked,
      'price': price,
      'vendor_id': vendorId,
      'vendor_name': vendorName,
      'is_sale': isSale,
      'discount_type': discountType,
      'discount_value': discountValue,
      'variations': variations?.map((v) => v.toJson()).toList(),
      'likes': likes,
      'image': image,
      'images': images?.map((i) => i.toJson()).toList(),
      'created_at': createdAt,
      'updated_at': updatedAt,
      'account_type': accountType,
      'whatsapp_number': whastappNum,
      'details': details,
    };
  }

  ProductData copyWith(
      {int? id,
      String? name,
      String? description,
      String? code,
      String? category,
      String? price,
      int? vendorId,
      String? vendorName,
      int? isSale,
      bool? isLiked,
      String? discountType,
      String? discountValue,
      List<Variation>? variations,
      int? likes,
      String? image,
      List<ImageData>? images,
      String? createdAt,
      String? updatedAt,
      String? whastappNum,
      String? accountType,
      List<Detail>? details, // Added details in copyWith
      int? active}) {
    return ProductData(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        code: code ?? this.code,
        category: category ?? this.category,
        price: price ?? this.price,
        vendorId: vendorId ?? this.vendorId,
        vendorName: vendorName ?? this.vendorName,
        isSale: isSale ?? this.isSale,
        isLiked: isLiked ?? this.isLiked,
        discountType: discountType ?? this.discountType,
        discountValue: discountValue ?? this.discountValue,
        variations: variations ?? this.variations,
        likes: likes ?? this.likes,
        image: image ?? this.image,
        images: images ?? this.images,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        whastappNum: updatedAt ?? this.whastappNum,
        accountType: updatedAt ?? this.accountType,
        details: details ?? this.details, // Include details in copyWith
        active: active ?? this.active);
  }
}

class Variation {
  final int? id; // Added id field
  final String? name;
  final int? stock;
  final String? price;
  final AttributeValue? attributeValue;
  final ColorData? color;

  Variation({
    this.id, // Added id parameter
    this.name,
    this.stock,
    this.price,
    this.attributeValue,
    this.color,
  });

  factory Variation.fromJson(Map<String, dynamic> json) {
    return Variation(
      id: json['id'], // Parse id from JSON
      name: json['name'],
      stock: json['stock'],
      price: json['price'],
      attributeValue: json['attribute_value'] != null
          ? AttributeValue.fromJson(json['attribute_value'])
          : null,
      color: json['color'] != null ? ColorData.fromJson(json['color']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // Include id in toJson
      'name': name,
      'stock': stock,
      'price': price,
      'attribute_value': attributeValue?.toJson(),
      'color': color?.toJson(),
    };
  }
}

class AttributeValue {
  final int? id;
  final String? name;
  final String? attribute;

  AttributeValue({
    this.id,
    this.name,
    this.attribute,
  });

  factory AttributeValue.fromJson(Map<String, dynamic> json) {
    return AttributeValue(
      id: json['id'],
      name: json['name'],
      attribute: json['attribute'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'attribute': attribute,
    };
  }
}

class ColorData {
  final int? id;
  final String? name;
  final String? code;

  ColorData({
    this.id,
    this.name,
    this.code,
  });

  factory ColorData.fromJson(Map<String, dynamic> json) {
    return ColorData(
      id: json['id'],
      name: json['name'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
    };
  }
}

class ImageData {
  final String? url;

  ImageData({
    this.url,
  });

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }
}

class Detail {
  final String? quality;
  final String? material;

  Detail({this.quality, this.material});

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      quality: json['quality'],
      material: json['material'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'quality': quality, 'material': material};
  }
}
