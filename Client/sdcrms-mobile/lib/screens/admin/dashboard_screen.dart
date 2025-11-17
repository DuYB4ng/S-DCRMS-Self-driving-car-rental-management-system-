import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../responsive.dart';
import '../../controllers/menu_app_controller.dart';
import '../../models/dashboard_stats.dart';
import 'system_monitoring_screen.dart';
import 'reports_screen.dart';
import 'financial_tracking_screen.dart';
import 'car_management_screen.dart';
import 'notification_screen.dart';
import 'third_party_payment_screen.dart';
import 'realtime_booking_screen.dart';
import 'components/header.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final DashboardStats _stats = DashboardStats(
    totalUsers: 1234,
    activeBookings: 56,
    revenue: 125000,
    totalCars: 89,
    systemHealth: 98.5,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      _buildWelcomeSection(),
                      const SizedBox(height: defaultPadding),
                      _buildStatsGrid(),
                      const SizedBox(height: defaultPadding),
                      _buildFleetSection(),
                      const SizedBox(height: defaultPadding),
                      _buildMainFunctionsGrid(),
                      const SizedBox(height: defaultPadding),
                      _buildRecentActivities(),
                      if (Responsive.isMobile(context))
                        const SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context))
                        _buildSystemFeaturesGrid(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  const SizedBox(width: defaultPadding),
                if (!Responsive.isMobile(context))
                  Expanded(flex: 2, child: _buildSystemFeaturesGrid()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu, color: textColor),
            onPressed: context.read<MenuAppController>().controlMenu,
          ),
        if (!Responsive.isMobile(context))
          const Text(
            "Dashboard",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        const Expanded(child: SearchField()),
        const ProfileCard(),
      ],
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: const EdgeInsets.all(defaultPadding * 1.5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primaryColor, accentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chào mừng trở lại!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Admin Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sức khỏe hệ thống: ${_stats.systemHealth}%',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.admin_panel_settings,
              color: Colors.white,
              size: 48,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.isMobile(context) ? 2 : 4,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: Responsive.isMobile(context) ? 1.3 : 1.5,
      ),
      itemBuilder: (context, index) => _buildStatCard(index),
    );
  }

  Widget _buildStatCard(int index) {
    final stats = [
      {
        'title': 'Tổng người dùng',
        'value': _stats.totalUsers.toString(),
        'icon': Icons.people_outline,
        'color': const Color(0xFF3B82F6),
        'percent': '+12.5%',
      },
      {
        'title': 'Đặt xe hoạt động',
        'value': _stats.activeBookings.toString(),
        'icon': Icons.directions_car_outlined,
        'color': successColor,
        'percent': '+8.3%',
      },
      {
        'title': 'Doanh thu',
        'value': '${(_stats.revenue / 1000).toStringAsFixed(0)}K',
        'icon': Icons.attach_money,
        'color': warningColor,
        'percent': '+15.7%',
      },
      {
        'title': 'Tổng xe',
        'value': _stats.totalCars.toString(),
        'icon': Icons.car_rental,
        'color': primaryColor,
        'percent': '+5.2%',
      },
    ];

    final stat = stats[index];
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(defaultPadding * 0.75),
                decoration: BoxDecoration(
                  color: (stat['color'] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  stat['icon'] as IconData,
                  color: stat['color'] as Color,
                  size: 20,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding * 0.5,
                  vertical: defaultPadding * 0.25,
                ),
                decoration: BoxDecoration(
                  color: successColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  stat['percent'] as String,
                  style: const TextStyle(
                    color: successColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Text(
            stat['title'] as String,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: textSecondaryColor),
          ),
          Text(
            stat['value'] as String,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // Fleet Section (tương tự MyFiles)
  Widget _buildFleetSection() {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
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
              const Text(
                'Đội xe của tôi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CarManagementScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Thêm xe'),
                style: TextButton.styleFrom(foregroundColor: primaryColor),
              ),
            ],
          ),
          const SizedBox(height: defaultPadding),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: Responsive.isMobile(context) ? 2 : 4,
            crossAxisSpacing: defaultPadding,
            mainAxisSpacing: defaultPadding,
            childAspectRatio: 1.3,
            children: [
              _buildFleetCard(
                'Sedan',
                '32',
                Icons.directions_car,
                const Color(0xFF3B82F6),
              ),
              _buildFleetCard('SUV', '24', Icons.car_rental, successColor),
              _buildFleetCard(
                'Hatchback',
                '18',
                Icons.electric_car,
                warningColor,
              ),
              _buildFleetCard('MPV', '15', Icons.airport_shuttle, dangerColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFleetCard(
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 6),
          Text(
            count,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(fontSize: 11, color: textSecondaryColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMainFunctionsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: Responsive.isMobile(context) ? 2 : 4,
      crossAxisSpacing: defaultPadding,
      mainAxisSpacing: defaultPadding,
      childAspectRatio: 1.2,
      children: [
        _buildMenuCard(
          'Giám sát hệ thống',
          Icons.security,
          primaryColor,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SystemMonitoringScreen(),
            ),
          ),
        ),
        _buildMenuCard(
          'Báo cáo',
          Icons.bar_chart,
          const Color(0xFF3B82F6),
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReportsScreen()),
          ),
        ),
        _buildMenuCard(
          'Giao dịch',
          Icons.account_balance_wallet,
          successColor,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FinancialTrackingScreen(),
            ),
          ),
        ),
        _buildMenuCard('Quản lý xe', Icons.directions_car, warningColor, () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CarManagementScreen(),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildMenuCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(defaultPadding * 0.75),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: defaultPadding / 2),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Recent Activities (tương tự Recent Files)
  Widget _buildRecentActivities() {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hoạt động gần đây',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: defaultPadding),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final activities = [
                {
                  'icon': Icons.person_add,
                  'title': 'Người dùng mới đăng ký',
                  'time': '5 phút trước',
                  'color': successColor,
                },
                {
                  'icon': Icons.book_online,
                  'title': 'Đặt xe mới #BR001234',
                  'time': '12 phút trước',
                  'color': primaryColor,
                },
                {
                  'icon': Icons.payment,
                  'title': 'Thanh toán hoàn tất ₫450,000',
                  'time': '25 phút trước',
                  'color': warningColor,
                },
                {
                  'icon': Icons.build,
                  'title': 'Xe cần bảo trì #CAR-125',
                  'time': '1 giờ trước',
                  'color': dangerColor,
                },
                {
                  'icon': Icons.star,
                  'title': 'Đánh giá 5 sao từ khách hàng',
                  'time': '2 giờ trước',
                  'color': warningColor,
                },
              ];

              final activity = activities[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (activity['color'] as Color).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    activity['icon'] as IconData,
                    color: activity['color'] as Color,
                    size: 20,
                  ),
                ),
                title: Text(
                  activity['title'] as String,
                  style: TextStyle(fontSize: 14, color: textColor),
                ),
                subtitle: Text(
                  activity['time'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: textSecondaryColor,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert, size: 18),
                  color: textSecondaryColor,
                  onPressed: () {},
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSystemFeaturesGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tính năng hệ thống',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: defaultPadding),
        _buildFeatureCard(
          'Hệ thống thông báo',
          Icons.notifications_active_outlined,
          dangerColor,
          badge: '5',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: defaultPadding),
        _buildFeatureCard(
          'Đặt xe thời gian thực',
          Icons.timer_outlined,
          const Color(0xFF8B5CF6),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RealTimeBookingScreen()),
            );
          },
        ),
        const SizedBox(height: defaultPadding),
        _buildFeatureCard(
          'Thanh toán bên thứ ba',
          Icons.payment,
          successColor,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ThirdPartyPaymentScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFeatureCard(
    String title,
    IconData icon,
    Color color, {
    String? badge,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(defaultPadding * 0.75),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: defaultPadding),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: textColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding * 0.5,
                  vertical: defaultPadding * 0.25,
                ),
                decoration: BoxDecoration(
                  color: dangerColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
