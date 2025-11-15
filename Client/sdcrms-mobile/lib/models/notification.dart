class Notification {
  final int? notificationId;
  final int userId;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool read;
  final String linkUrl;

  Notification({
    this.notificationId,
    required this.userId,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.read,
    required this.linkUrl,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      notificationId: json['notificationID'],
      userId: json['userID'],
      title: json['title'],
      message: json['message'],
      createdAt: DateTime.parse(json['createdAt']),
      read: json['read'],
      linkUrl: json['linkURL'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userId,
      'title': title,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'read': read,
      'linkURL': linkUrl,
    };
  }
}
