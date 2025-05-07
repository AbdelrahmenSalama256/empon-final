class RecentViewItem {
  final int id;
  final String imageUrl;

  RecentViewItem({
    required this.id,
    required this.imageUrl,
  });

  factory RecentViewItem.fromJson(Map<String, dynamic> json) {
    return RecentViewItem(
      id: json['id'],
      imageUrl: json['image_url'],
    );
  }
}

class RecentViewModel {
  final List<RecentViewItem> items;

  RecentViewModel({required this.items});

  factory RecentViewModel.fromJson(Map<String, dynamic> json) {
    return RecentViewModel(
      items: List.from(json['data'])
          .map((e) => RecentViewItem.fromJson(e))
          .toList(),
    );
  }
}
