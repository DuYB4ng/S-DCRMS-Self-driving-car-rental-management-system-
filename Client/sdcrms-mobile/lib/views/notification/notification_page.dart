import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/notification_viewmodel.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load all notifications (in production, filter by current user)
      context.read<NotificationViewModel>().loadAllNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          Consumer<NotificationViewModel>(
            builder: (context, viewModel, child) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Chip(
                    label: Text('${viewModel.unreadCount} unread'),
                    backgroundColor: viewModel.unreadCount > 0
                        ? Colors.red[100]
                        : Colors.grey[200],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<NotificationViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading && viewModel.notifications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${viewModel.errorMessage}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => viewModel.loadAllNotifications(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (viewModel.notifications.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No notifications',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => viewModel.loadAllNotifications(),
            child: ListView.builder(
              itemCount: viewModel.notifications.length,
              itemBuilder: (context, index) {
                final notification = viewModel.notifications[index];
                return Dismissible(
                  key: Key(notification.notificationID.toString()),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    viewModel.deleteNotification(notification.notificationID);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Notification deleted')),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    elevation: notification.isRead ? 0 : 2,
                    color: notification.isRead ? Colors.grey[50] : Colors.white,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: notification.isRead
                            ? Colors.grey
                            : _getNotificationColor(notification.notificationType),
                        child: Icon(
                          _getNotificationIcon(notification.notificationType),
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight: notification.isRead
                              ? FontWeight.normal
                              : FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(notification.message),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('MMM dd, yyyy HH:mm')
                                .format(notification.createdAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      trailing: notification.isRead
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.check_circle_outline),
                              color: Colors.blue,
                              onPressed: () {
                                viewModel.markAsRead(notification.notificationID);
                              },
                            ),
                      isThreeLine: true,
                      onTap: () {
                        if (!notification.isRead) {
                          viewModel.markAsRead(notification.notificationID);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Color _getNotificationColor(String type) {
    switch (type.toLowerCase()) {
      case 'info':
        return Colors.blue;
      case 'warning':
        return Colors.orange;
      case 'error':
        return Colors.red;
      case 'success':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'info':
        return Icons.info;
      case 'warning':
        return Icons.warning;
      case 'error':
        return Icons.error;
      case 'success':
        return Icons.check_circle;
      default:
        return Icons.notifications;
    }
  }
}
