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
  final Account account;
  final int totalFollowers;
  final int totalSubscriptions;
  final int totalFavorites;
  final double avgProductPrice;
  final int recentViews;
  final int totalProductLikes;
  final Map<String, int> visitorsCountForYear;
  final double totalRevenue;
  final MostSoldProduct? mostSoldProduct;
  final List<WalletTransaction> walletTransactions;

  StatisticsData({
    required this.account,
    required this.totalFollowers,
    required this.totalSubscriptions,
    required this.totalFavorites,
    required this.avgProductPrice,
    required this.recentViews,
    required this.totalProductLikes,
    required this.visitorsCountForYear,
    required this.totalRevenue,
    this.mostSoldProduct,
    required this.walletTransactions,
  });

  factory StatisticsData.fromJson(Map<String, dynamic> json) {
    return StatisticsData(
        account: Account.fromJson(json['account']),
        totalFollowers: json['total_followers'],
        totalSubscriptions: json['total_ads'],
        totalFavorites: json['total_favorites'],
        avgProductPrice: (json['avg_product_price'] as num).toDouble(),
        recentViews: json['recent_views'],
        totalProductLikes: json['total_engagements'],
        visitorsCountForYear: Map<String, int>.from(
          (json['visitors_count_for_this_year'] as Map<String, dynamic>).map(
            (k, v) => MapEntry(k, v as int),
          ),
        ),
        totalRevenue: (json['total_revenue'] as num).toDouble(),
        mostSoldProduct: json['most_sold_product'] != null
            ? MostSoldProduct.fromJson(json['most_sold_product'])
            : null,
        walletTransactions: (json['wallet_transactions'] != null &&
                json['wallet_transactions'] is List)
            ? (json['wallet_transactions'] as List)
                .map((e) => WalletTransaction.fromJson(e))
                .toList()
            : []);
  }
}

class Account {
  final String name;
  final String logo;
  final String cover;

  Account({
    required this.name,
    required this.logo,
    required this.cover,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      name: json['name'],
      logo: json['logo'],
      cover: json['cover'],
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

class WalletTransaction {
  final int id;
  final String amount;
  final String type;
  final DateTime createdAt;

  WalletTransaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.createdAt,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['id'],
      amount: json['amount'],
      type: json['type'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
