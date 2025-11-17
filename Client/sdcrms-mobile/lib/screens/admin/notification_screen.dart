import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants.dart';
import '../../models/notification.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String selectedFilter = 'Tất cả';

  // Dữ liệu mẫu
  List<NotificationItem> notifications = [
    NotificationItem(
      id: '1',
      title: 'Đặt xe mới',
      message:
          'Khách hàng Nguyễn Văn A đã đặt xe Toyota Vios từ 20/11 đến 25/11',
      type: 'booking',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isRead: false,
      data: {'bookingId': 'BK001', 'carId': '1'},
    ),
    NotificationItem(
      id: '2',
      title: 'Thanh toán thành công',
      message: 'Đơn hàng #BK002 đã được thanh toán 5,000,000đ',
      type: 'payment',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
      data: {'amount': 5000000, 'bookingId': 'BK002'},
    ),
    NotificationItem(
      id: '3',
      title: 'Xe cần bảo trì',
      message: 'VinFast VF6 (30C-11111) đã đạt 10,000km - cần bảo trì định kỳ',
      type: 'maintenance',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: true,
      data: {'carId': '3', 'mileage': 10000},
    ),
    NotificationItem(
      id: '4',
      title: 'Cập nhật hệ thống',
      message: 'Phiên bản mới 2.1.0 đã được cập nhật với nhiều tính năng mới',
      type: 'system',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
      data: {'version': '2.1.0'},
    ),
    NotificationItem(
      id: '5',
      title: 'Đặt xe sắp hết hạn',
      message: 'Khách hàng Trần Thị B sẽ trả xe Mazda 3 vào ngày mai (18/11)',
      type: 'booking',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      data: {'bookingId': 'BK003', 'carId': '2'},
    ),
  ];

  List<NotificationItem> get filteredNotifications {
    if (selectedFilter == 'Tất cả') {
      return notifications;
    } else if (selectedFilter == 'Chưa đọc') {
      return notifications.where((n) => !n.isRead).toList();
    } else {
      // Filter by type
      String type = '';
      switch (selectedFilter) {
        case 'Đặt xe':
          type = 'booking';
          break;
        case 'Thanh toán':
          type = 'payment';
          break;
        case 'Bảo trì':
          type = 'maintenance';
          break;
        case 'Hệ thống':
          type = 'system';
          break;
      }
      return notifications.where((n) => n.type == type).toList();
    }
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông báo',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            if (unreadCount > 0)
              Text(
                '$unreadCount chưa đọc',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
          ],
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                'Đọc tất cả',
                style: TextStyle(color: Colors.white),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            onPressed: _clearAllNotifications,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: filteredNotifications.isEmpty
                ? _buildEmptyState()
                : _buildNotificationList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = [
      'Tất cả',
      'Chưa đọc',
      'Đặt xe',
      'Thanh toán',
      'Bảo trì',
      'Hệ thống',
    ];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: 8,
      ),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            final isSelected = filter == selectedFilter;
            int count = 0;

            if (filter == 'Tất cả') {
              count = notifications.length;
            } else if (filter == 'Chưa đọc') {
              count = unreadCount;
            } else {
              String type = '';
              switch (filter) {
                case 'Đặt xe':
                  type = 'booking';
                  break;
                case 'Thanh toán':
                  type = 'payment';
                  break;
                case 'Bảo trì':
                  type = 'maintenance';
                  break;
                case 'Hệ thống':
                  type = 'system';
                  break;
              }
              count = notifications.where((n) => n.type == type).length;
            }

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(filter),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.3)
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        count.toString(),
                        style: TextStyle(
                          fontSize: 11,
                          color: isSelected ? Colors.white : textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    selectedFilter = filter;
                  });
                },
                selectedColor: primaryColor,
                backgroundColor: Colors.grey[200],
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : textColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isSelected ? primaryColor : Colors.grey[300]!,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNotificationList() {
    return ListView.builder(
      padding: const EdgeInsets.all(defaultPadding),
      itemCount: filteredNotifications.length,
      itemBuilder: (context, index) {
        return _buildNotificationCard(filteredNotifications[index]);
      },
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    IconData icon;
    Color iconColor;

    switch (notification.type) {
      case 'booking':
        icon = Icons.event_available;
        iconColor = primaryColor;
        break;
      case 'payment':
        icon = Icons.payment;
        iconColor = successColor;
        break;
      case 'maintenance':
        icon = Icons.build;
        iconColor = warningColor;
        break;
      case 'system':
        icon = Icons.notifications_active;
        iconColor = accentColor;
        break;
      default:
        icon = Icons.notifications;
        iconColor = textSecondaryColor;
    }

    final timeAgo = _getTimeAgo(notification.timestamp);

    return Card(
      margin: const EdgeInsets.only(bottom: defaultPadding),
      elevation: notification.isRead ? 0 : 2,
      color: notification.isRead
          ? Colors.white
          : primaryColor.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: notification.isRead
              ? Colors.grey[200]!
              : primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _viewNotificationDetail(notification),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: notification.isRead
                                  ? FontWeight.w600
                                  : FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: dangerColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: textSecondaryColor,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: textSecondaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          timeAgo,
                          style: TextStyle(
                            fontSize: 12,
                            color: textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, size: 20),
                onPressed: () => _showNotificationOptions(notification),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Không có thông báo',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bạn sẽ nhận được thông báo ở đây',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Vừa xong';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      return DateFormat('dd/MM/yyyy HH:mm').format(timestamp);
    }
  }

  void _viewNotificationDetail(NotificationItem notification) {
    // Mark as read
    setState(() {
      final index = notifications.indexWhere((n) => n.id == notification.id);
      if (index != -1) {
        notifications[index] = notification.copyWith(isRead: true);
      }
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        IconData icon;
        Color iconColor;

        switch (notification.type) {
          case 'booking':
            icon = Icons.event_available;
            iconColor = primaryColor;
            break;
          case 'payment':
            icon = Icons.payment;
            iconColor = successColor;
            break;
          case 'maintenance':
            icon = Icons.build;
            iconColor = warningColor;
            break;
          case 'system':
            icon = Icons.notifications_active;
            iconColor = accentColor;
            break;
          default:
            icon = Icons.notifications;
            iconColor = textSecondaryColor;
        }

        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: iconColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, color: iconColor, size: 32),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notification.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat(
                                  'dd/MM/yyyy HH:mm',
                                ).format(notification.timestamp),
                                style: TextStyle(
                                  fontSize: 13,
                                  color: textSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      notification.message,
                      style: const TextStyle(
                        fontSize: 16,
                        color: textColor,
                        height: 1.6,
                      ),
                    ),
                    if (notification.data != null) ...[
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Chi tiết',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 12),
                            ...notification.data!.entries.map((entry) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Text(
                                      '${entry.key}: ',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: textSecondaryColor,
                                      ),
                                    ),
                                    Text(
                                      entry.value.toString(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _deleteNotification(notification);
                            },
                            icon: const Icon(Icons.delete_outline),
                            label: const Text('Xóa'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: dangerColor),
                              foregroundColor: dangerColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              // Navigate to related screen based on type
                            },
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('Xem chi tiết'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showNotificationOptions(NotificationItem notification) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!notification.isRead)
                ListTile(
                  leading: const Icon(
                    Icons.mark_email_read,
                    color: primaryColor,
                  ),
                  title: const Text('Đánh dấu đã đọc'),
                  onTap: () {
                    Navigator.pop(context);
                    _markAsRead(notification);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: dangerColor),
                title: const Text('Xóa thông báo'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteNotification(notification);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _markAsRead(NotificationItem notification) {
    setState(() {
      final index = notifications.indexWhere((n) => n.id == notification.id);
      if (index != -1) {
        notifications[index] = notification.copyWith(isRead: true);
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      notifications = notifications
          .map((n) => n.copyWith(isRead: true))
          .toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã đánh dấu tất cả là đã đọc')),
    );
  }

  void _deleteNotification(NotificationItem notification) {
    setState(() {
      notifications.removeWhere((n) => n.id == notification.id);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã xóa thông báo')));
  }

  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xóa tất cả thông báo'),
          content: const Text('Bạn có chắc chắn muốn xóa tất cả thông báo?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  notifications.clear();
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã xóa tất cả thông báo')),
                );
              },
              child: const Text('Xóa', style: TextStyle(color: dangerColor)),
            ),
          ],
        );
      },
    );
  }
}
