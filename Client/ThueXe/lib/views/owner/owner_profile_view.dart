import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../viewmodels/profile_viewmodel.dart';

class ProfileView extends StatefulWidget {
  final Function(int) onMenuTap;

  const ProfileView({super.key, required this.onMenuTap});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().loadUserInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();

    // ✅ Quan trọng: không bọc Scaffold nữa nếu bạn dùng trong OwnerHome (tránh lồng Scaffold)
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                      if (vm.phone != null && vm.phone!.isNotEmpty) ...[
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

            _menuItem(Icons.person, "Thông tin cá nhân", () {}),

            _menuItem(Icons.list_alt, "Đơn hàng của tôi", () {
              widget.onMenuTap(1); // nhảy qua tab Đơn hàng
            }),

            const SizedBox(height: 24),
            const Divider(),

            const SizedBox(height: 8),
            const Text(
              "Khác",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),
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

  Widget _menuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, size: 26),
      title: Text(title, style: const TextStyle(fontSize: 18)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Đăng xuất"),
          content: const Text("Bạn có chắc chắn muốn đăng xuất khỏi tài khoản này?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop();

                try {
                  await FirebaseAuth.instance.signOut();
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Lỗi khi đăng xuất: $e")),
                    );
                  }
                  return;
                }

                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    "/login",
                    (route) => false,
                  );
                }
              },
              child: const Text("Đăng xuất", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
