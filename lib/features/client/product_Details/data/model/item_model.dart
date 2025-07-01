abstract class ItemModel {
  int get id;
  String get name;
  int get likes;
  int get active;
  bool get isLoved;
  bool get isLiked;
}

class ProductItem implements ItemModel {
  final dynamic
      product; // Assuming product is from SearchCubit.productModel.data

  ProductItem(this.product);

  @override
  int get id => product?.id ?? 0;
  @override
  String get name => product?.name ?? 'Unknown Product';
  @override
  int get likes => product?.likes ?? 0;
  @override
  int get active => product?.active ?? 1;
  @override
  bool get isLoved => product?.isLoved ?? false;
  @override
  bool get isLiked => product?.isLiked ?? false;
}

class ServiceItem implements ItemModel {
  final dynamic
      service; // Assuming service is from SearchCubit.serviceModel.data

  ServiceItem(this.service);

  @override
  int get id => service?.id ?? 0;
  @override
  String get name => service?.name ?? 'Unknown Service';
  @override
  int get likes => service?.likes ?? 0;
  @override
  int get active => service?.active == true ? 1 : 0;
  @override
  bool get isLoved => false;
  @override
  bool get isLiked => service?.isLiked ?? false;
}
