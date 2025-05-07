class SearchHistoryModel {
  final bool success;
  final String message;
  final List<SearchHistoryItem> history;

  const SearchHistoryModel({
    required this.success,
    required this.message,
    required this.history,
  });

  factory SearchHistoryModel.fromJson(Map<String, dynamic> json) {
    return SearchHistoryModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      history: (json['data'] as List<dynamic>? ?? [])
          .map((item) => SearchHistoryItem.fromJson(item))
          .toList(),
    );
  }
}

class SearchHistoryItem {
  final int id;
  final String search;

  const SearchHistoryItem({
    required this.id,
    required this.search,
  });

  factory SearchHistoryItem.fromJson(Map<String, dynamic> json) {
    return SearchHistoryItem(
      id: json['id'] ?? 0,
      search: json['search'] ?? '',
    );
  }
}
