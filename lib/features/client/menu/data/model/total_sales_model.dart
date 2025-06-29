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
  final int deliveredOrdersCount;
  final double deliveredOrdersAmount;
  final Map<String, double> chart;

  StatisticsData({
    required this.deliveredOrdersCount,
    required this.deliveredOrdersAmount,
    required this.chart,
  });

  factory StatisticsData.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> chartJson = json['chart'] ?? {};
    final Map<String, double> parsedChart = chartJson.map((key, value) {
      return MapEntry(key, (value as num).toDouble());
    });

    return StatisticsData(
      deliveredOrdersCount: json['delivered_orders_count'],
      deliveredOrdersAmount:
          (json['delivered_orders_amount'] as num).toDouble(),
      chart: parsedChart,
    );
  }
}
