class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
  final String? image;
  final bool isRead;
  final List<String> readBy;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.image,
    required this.isRead,
    required this.readBy,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'info',
      image: json['image'],
      isRead: json['isRead'] ?? false,
      readBy: List<String>.from(json['readBy'] ?? []),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class NotificationResponse {
  final bool success;
  final List<NotificationModel> notifications;

  NotificationResponse({
    required this.success,
    required this.notifications,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      success: json['success'] ?? false,
      notifications: (json['notifications'] as List? ?? [])
          .map((i) => NotificationModel.fromJson(i))
          .toList(),
    );
  }
}
