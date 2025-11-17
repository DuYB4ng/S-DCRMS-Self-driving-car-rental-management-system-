import 'package:flutter/material.dart';
import '../../constants.dart';

class SystemMonitoringScreen extends StatefulWidget {
  const SystemMonitoringScreen({super.key});

  @override
  State<SystemMonitoringScreen> createState() => _SystemMonitoringScreenState();
}

class _SystemMonitoringScreenState extends State<SystemMonitoringScreen> {
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
        title: const Text(
          'Giám sát hệ thống & Phân quyền',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSystemHealthSection(),
            const SizedBox(height: 24),
            _buildServerStatusSection(),
            const SizedBox(height: 24),
            _buildUserRolesSection(),
            const SizedBox(height: 24),
            _buildPermissionsSection(),
            const SizedBox(height: 24),
            _buildActivityLogsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemHealthSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.health_and_safety, color: successColor, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Sức khỏe hệ thống',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildHealthMetric('CPU Usage', 45.2, successColor),
          const SizedBox(height: 12),
          _buildHealthMetric('Memory Usage', 68.5, warningColor),
          const SizedBox(height: 12),
          _buildHealthMetric('Database Load', 32.1, successColor),
          const SizedBox(height: 12),
          _buildHealthMetric('API Response Time', 125, accentColor, unit: 'ms'),
        ],
      ),
    );
  }

  Widget _buildHealthMetric(
    String label,
    double value,
    Color color, {
    String unit = '%',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: textSecondaryColor),
            ),
            Text(
              '$value$unit',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: unit == '%' ? value / 100 : value / 200,
            backgroundColor: color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildServerStatusSection() {
    final servers = [
      {'name': 'API Server', 'status': 'Online', 'uptime': '99.9%'},
      {'name': 'Database Server', 'status': 'Online', 'uptime': '99.8%'},
      {'name': 'Payment Gateway', 'status': 'Online', 'uptime': '99.5%'},
      {'name': 'File Server', 'status': 'Maintenance', 'uptime': '98.2%'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.dns, color: primaryColor, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Trạng thái Server',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...servers.map(
            (server) => _buildServerItem(
              server['name']!,
              server['status']!,
              server['uptime']!,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServerItem(String name, String status, String uptime) {
    final isOnline = status == 'Online';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isOnline ? successColor : warningColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    color: isOnline ? successColor : warningColor,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Uptime: $uptime',
            style: TextStyle(fontSize: 12, color: textSecondaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildUserRolesSection() {
    final roles = [
      {'name': 'Admin', 'count': '12', 'color': primaryColor},
      {'name': 'Manager', 'count': '25', 'color': accentColor},
      {'name': 'Staff', 'count': '87', 'color': successColor},
      {'name': 'Customer', 'count': '1234', 'color': textSecondaryColor},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.group, color: primaryColor, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Phân quyền người dùng',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.add_circle, color: primaryColor),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...roles.map(
            (role) => _buildRoleItem(
              role['name'] as String,
              role['count'] as String,
              role['color'] as Color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleItem(String name, String count, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.shield, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  count,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: color, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionsSection() {
    final permissions = [
      'Quản lý người dùng',
      'Quản lý xe',
      'Quản lý đặt xe',
      'Xem báo cáo tài chính',
      'Cấu hình hệ thống',
      'Quản lý thanh toán',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.key, color: warningColor, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Quyền hệ thống',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: permissions
                .map(
                  (permission) => Chip(
                    label: Text(permission, style: TextStyle(fontSize: 12)),
                    backgroundColor: primaryColor.withValues(alpha: 0.1),
                    side: BorderSide(
                      color: primaryColor.withValues(alpha: 0.3),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityLogsSection() {
    final logs = [
      {
        'user': 'Admin',
        'action': 'Cập nhật quyền người dùng',
        'time': '2 phút trước',
        'icon': Icons.edit,
      },
      {
        'user': 'System',
        'action': 'Backup database thành công',
        'time': '15 phút trước',
        'icon': Icons.backup,
      },
      {
        'user': 'Manager',
        'action': 'Duyệt đơn đặt xe #1234',
        'time': '1 giờ trước',
        'icon': Icons.check_circle,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.history, color: accentColor, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Nhật ký hoạt động',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              TextButton(onPressed: () {}, child: const Text('Xem tất cả')),
            ],
          ),
          const SizedBox(height: 16),
          ...logs.map(
            (log) => _buildLogItem(
              log['user'] as String,
              log['action'] as String,
              log['time'] as String,
              log['icon'] as IconData,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogItem(String user, String action, String time, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: accentColor, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 13, color: textColor),
                    children: [
                      TextSpan(
                        text: user,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(text: action),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: TextStyle(fontSize: 11, color: textSecondaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
