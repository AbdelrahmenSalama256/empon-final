class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;
  final String size;
  final String category;
  final String subCategory;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.size,
    required this.category,
    required this.subCategory,
    required this.imageUrl,
  });

  CartItem copyWith({
    String? id,
    String? title,
    double? price,
    int? quantity,
    String? size,
    String? category,
    String? subCategory,
    String? imageUrl,
  }) {
    return CartItem(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
