import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../admin/car_management_screen.dart';
import '../../admin/realtime_booking_screen.dart';
import '../../admin/notification_screen.dart';
import '../../admin/third_party_payment_screen.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: cardBgColor,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, accentColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.admin_panel_settings,
                    size: 40,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'SDCRMS Admin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 3,
                        color: Color.fromARGB(80, 0, 0, 0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          DrawerListTile(
            title: "Dashboard",
            icon: Icons.dashboard,
            press: () {
              Navigator.pop(context);
            },
          ),
          DrawerListTile(
            title: "Quản lý xe",
            icon: Icons.directions_car,
            press: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CarManagementScreen()),
              );
            },
          ),
          DrawerListTile(
            title: "Quản lý đặt xe",
            icon: Icons.car_rental,
            press: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RealTimeBookingScreen(),
                ),
              );
            },
          ),
          DrawerListTile(
            title: "Thanh toán",
            icon: Icons.payment,
            press: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ThirdPartyPaymentScreen(),
                ),
              );
            },
          ),
          DrawerListTile(
            title: "Thông báo",
            icon: Icons.notifications,
            press: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationScreen()),
              );
            },
          ),
          const Divider(color: textSecondaryColor),
          DrawerListTile(
            title: "Đăng xuất",
            icon: Icons.logout,
            press: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Đăng xuất'),
                  content: const Text('Bạn có chắc muốn đăng xuất?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Hủy'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Đã đăng xuất'),
                            backgroundColor: successColor,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: dangerColor,
                      ),
                      child: const Text('Đăng xuất'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.title,
    required this.icon,
    required this.press,
  });

  final String title;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Icon(icon, color: textColor, size: 20),
      title: Text(
        title,
        style: const TextStyle(color: textColor, fontSize: 14),
      ),
      hoverColor: primaryColor.withValues(alpha: 0.1),
    );
  }
}
