class HomeItem {
  final String id;
  final String title;
  final double price;
  final String imagePath;
  bool isFavorite;

  HomeItem({
    required this.id,
    required this.title,
    required this.price,
    required this.imagePath,
    this.isFavorite = false,
  });
}
