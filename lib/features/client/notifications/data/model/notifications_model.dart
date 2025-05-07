
class NotificationsModel {
  final bool success;
  final String message;
  final List<NotificationItem> notifications;

  const NotificationsModel({
    required this.success,
    required this.message,
    required this.notifications,
  });

  factory NotificationsModel.fromJson(Map<String, dynamic> json) {
    return NotificationsModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      notifications: (json['data'] as List<dynamic>? ?? [])
          .map((item) => NotificationItem.fromJson(item))
          .toList(),
    );
  }
}

class NotificationItem {
  final int id;
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final String time;
  final String notifiableType;
  final int notifiableId;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.time,
    required this.notifiableType,
    required this.notifiableId,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? '',
      isRead: json['is_read'] ?? false,
      time: json['time'] ?? '',
      notifiableType: json['notifiable_type'] ?? '',
      notifiableId: json['notifiable_id'] ?? 0,
    );
  }
}
