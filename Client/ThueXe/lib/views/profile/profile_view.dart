import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../viewmodels/profile_viewmodel.dart';

class ProfileView extends StatelessWidget {
  final Function(int) onMenuTap;

  const ProfileView({super.key, required this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProfileViewModel>(context);

    // Load thông tin user khi mở màn
    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm.loadUserInfo();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tài khoản"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông tin user
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  child: Text(
                    (vm.email != null && vm.email!.isNotEmpty)
                        ? vm.email![0].toUpperCase()
                        : "?",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vm.name ?? "Người dùng",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        vm.email ?? "Chưa có email",
                        style: const TextStyle(color: Colors.black54),
                      ),
                      if (vm.phone != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          vm.phone!,
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(),

            const SizedBox(height: 8),
            const Text(
              "Tài khoản",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),
            _menuItem(Icons.person, "Thông tin cá nhân", () {
              // TODO: mở màn chi tiết profile nếu muốn
            }),

            _menuItem(Icons.list_alt, "Đơn hàng của tôi", () {
              // chuyển sang tab Đơn hàng trong bottom nav
              onMenuTap(1);
            }),

            const SizedBox(height: 24),
            const Divider(),

            const SizedBox(height: 8),
            const Text(
              "Khác",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),
            // 🔥 Nút ĐĂNG XUẤT
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Đăng xuất",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () => _showLogoutDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, Function onTap) {
    return ListTile(
      leading: Icon(icon, size: 26),
      title: Text(title, style: const TextStyle(fontSize: 18)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => onTap(),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Đăng xuất"),
          content: const Text(
            "Bạn có chắc chắn muốn đăng xuất khỏi tài khoản này?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop(); // đóng dialog

                // 1. Sign out Firebase
                try {
                  await FirebaseAuth.instance.signOut();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Lỗi khi đăng xuất: $e")),
                  );
                  return;
                }

                // 2. Điều hướng về màn Login và xóa hết history (không back lại được)
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil("/login", (route) => false);
              },
              child: const Text(
                "Đăng xuất",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
