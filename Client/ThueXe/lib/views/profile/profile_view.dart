import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../viewmodels/profile_viewmodel.dart';

class ProfileView extends StatelessWidget {
  final Function(int) onMenuTap;

  ProfileView({required this.onMenuTap});


 @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProfileViewModel>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.loadUserInfo();
    });

    return Scaffold(
      appBar: AppBar(title: Text("Tài khoản")),
      body: Column(
        children: [
          SizedBox(height: 20),


          Text(
            vm.email ?? "",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 4),

          Text(
            vm.phone ?? "",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),

          Divider(height: 40),

          _menuItem(Icons.history, "Lịch sử đơn hàng", () {
            onMenuTap(1);
          }),

          _menuItem(Icons.settings, "Cài đặt", () {}),

          _menuItem(Icons.logout, "Đăng xuất", () {
            _showLogoutDialog(context);
          }),
        ],
      ),
    );
  }


  Widget _menuItem(IconData icon, String title, Function onTap) {
    return ListTile(
      leading: Icon(icon, size: 26),
      title: Text(title, style: TextStyle(fontSize: 18)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => onTap(),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    // (đã gửi ở tin trước)
  }
}
