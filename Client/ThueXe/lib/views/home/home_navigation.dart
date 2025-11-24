import 'package:flutter/material.dart';
import 'home_view.dart';
import '../profile/profile_view.dart';
import '../orders/orders_view.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/orders_viewmodel.dart';

class HomeNavigation extends StatefulWidget {
  @override
  _HomeNavigationState createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  int _currentIndex = 0;

  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();

    pages = [HomeView(), OrdersView(), ProfileView(onMenuTap: _changeTab)];
  }

  void _changeTab(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      final vm = Provider.of<OrdersViewModel>(context, listen: false);
      vm.refreshOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Color(0xFF226EA3),
        unselectedItemColor: Colors.black54,
        onTap: _changeTab,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang chủ"),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: "Đơn hàng",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Tài khoản"),
        ],
      ),
    );
  }
}
