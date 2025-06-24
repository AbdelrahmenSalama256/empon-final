class StatisticsResponse {
  final bool success;
  final String message;
  final StatisticsData data;

  StatisticsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory StatisticsResponse.fromJson(Map<String, dynamic> json) {
    return StatisticsResponse(
      success: json['success'],
      message: json['message'],
      data: StatisticsData.fromJson(json['data']),
    );
  }
}

class StatisticsData {
  final int totalFollowers;
  final int totalSubscriptions;
  final int totalFavorites;
  final double avgProductPrice;
  final int recentViews;
  final int totalProductLikes;
  final double totalRevenue;
  final MostSoldProduct mostSoldProduct;

  StatisticsData({
    required this.totalFollowers,
    required this.totalSubscriptions,
    required this.totalFavorites,
    required this.avgProductPrice,
    required this.recentViews,
    required this.totalProductLikes,
    required this.totalRevenue,
    required this.mostSoldProduct,
  });

  factory StatisticsData.fromJson(Map<String, dynamic> json) {
    return StatisticsData(
      totalFollowers: json['total_followers'],
      totalSubscriptions: json['total_subscriptions'],
      totalFavorites: json['total_favorites'],
      avgProductPrice: (json['avg_product_price'] as num).toDouble(),
      recentViews: json['recent_views'],
      totalProductLikes: json['total_product_likes'],
      totalRevenue: (json['total_revenue'] as num).toDouble(),
      mostSoldProduct: MostSoldProduct.fromJson(json['most_sold_product']),
    );
  }
}

class MostSoldProduct {
  final int id;
  final String name;
  final int totalSold;
  final String image;

  MostSoldProduct({
    required this.id,
    required this.name,
    required this.totalSold,
    required this.image,
  });

  factory MostSoldProduct.fromJson(Map<String, dynamic> json) {
    return MostSoldProduct(
      id: json['id'],
      name: json['name'],
      totalSold: json['total_sold'],
      image: json['image'],
    );
  }
}
