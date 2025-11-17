import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/menu_app_controller.dart';
import '../../responsive.dart';
import '../admin/dashboard_screen.dart';
import 'components/side_menu.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuAppController>().scaffoldKey,
      drawer: const SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị side menu cho desktop
            if (Responsive.isDesktop(context))
              const Expanded(flex: 1, child: SideMenu()),
            Expanded(flex: 5, child: const AdminDashboardScreen()),
          ],
        ),
      ),
    );
  }
}
