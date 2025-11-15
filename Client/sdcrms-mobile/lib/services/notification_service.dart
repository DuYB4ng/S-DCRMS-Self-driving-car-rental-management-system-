import '../core/network/api_client.dart';
import '../core/constants/api_constants.dart';
import '../models/notification.dart' as model;

class NotificationService {
  final ApiClient _apiClient = ApiClient();

  // GET all notifications
  Future<List<model.Notification>> getAllNotifications() async {
    try {
      final response = await _apiClient.get(ApiConstants.notificationEndpoint);
      final List<dynamic> data = response.data;
      return data.map((json) => model.Notification.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  // GET notifications by user ID
  Future<List<model.Notification>> getNotificationsByUserId(int userId) async {
    try {
      final response = await _apiClient.get(
        '${ApiConstants.notificationEndpoint}/user/$userId',
      );
      final List<dynamic> data = response.data;
      return data.map((json) => model.Notification.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch user notifications: $e');
    }
  }

  // POST create notification
  Future<model.Notification> createNotification(model.Notification notification) async {
    try {
      final response = await _apiClient.post(
        ApiConstants.notificationEndpoint,
        data: notification.toJson(),
      );
      return model.Notification.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create notification: $e');
    }
  }

  // PUT mark as read
  Future<void> markAsRead(int notificationId) async {
    try {
      await _apiClient.put(
        '${ApiConstants.notificationEndpoint}/$notificationId/read',
      );
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  // DELETE notification
  Future<void> deleteNotification(int notificationId) async {
    try {
      await _apiClient.delete(
        '${ApiConstants.notificationEndpoint}/$notificationId',
      );
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }
}
