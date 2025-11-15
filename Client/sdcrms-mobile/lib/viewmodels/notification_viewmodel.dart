import 'package:flutter/foundation.dart';
import '../models/notification.dart';
import '../services/notification_service.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService();

  List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  // Load all notifications
  Future<void> loadAllNotifications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _notifications = await _notificationService.getAllNotifications();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load notifications for specific user
  Future<void> loadUserNotifications(int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _notifications = await _notificationService.getNotificationsByUserId(userId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create notification
  Future<bool> createNotification(NotificationModel notification) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _notificationService.createNotification(notification);
      await loadAllNotifications(); // Refresh list
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mark notification as read
  Future<bool> markAsRead(int notificationId) async {
    try {
      await _notificationService.markAsRead(notificationId);
      
      // Update local state
      final index = _notifications.indexWhere((n) => n.notificationID == notificationId);
      if (index != -1) {
        _notifications[index] = NotificationModel(
          notificationID: _notifications[index].notificationID,
          userID: _notifications[index].userID,
          title: _notifications[index].title,
          message: _notifications[index].message,
          isRead: true,
          createdAt: _notifications[index].createdAt,
          notificationType: _notifications[index].notificationType,
        );
        notifyListeners();
      }
      
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Delete notification
  Future<bool> deleteNotification(int notificationId) async {
    try {
      await _notificationService.deleteNotification(notificationId);
      
      // Update local state
      _notifications.removeWhere((n) => n.notificationID == notificationId);
      notifyListeners();
      
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
