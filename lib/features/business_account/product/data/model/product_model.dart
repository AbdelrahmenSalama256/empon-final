class ProductModel {
  bool? success;
  String? message;
  Data? data;

  ProductModel({this.success, this.message, this.data});

  ProductModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }


}

class Details{
  String? key;
  String? value;

  Details({this.key, this.value});

  Details.fromJson(Map<String, dynamic> json) {
    key = json['quality'];
    value = json['material'];
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

}