import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  final Function(int) onMenuTap;

  ProfileView({required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tài khoản")),
      body: Column(
        children: [
          _menuItem(Icons.history, "Lịch sử đơn hàng", () {
            onMenuTap(1);   // chuyển sang tab Đơn hàng
          }),

          _menuItem(Icons.settings, "Cài đặt", () {}),

          _menuItem(Icons.logout, "Đăng xuất", () {}),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, Function onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => onTap(),
    );
  }
}
