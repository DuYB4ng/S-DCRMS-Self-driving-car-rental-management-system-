import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/profile_viewmodel.dart';

class ProfileDetailView extends StatefulWidget {
  const ProfileDetailView({super.key});

  @override
  State<ProfileDetailView> createState() => _ProfileDetailViewState();
}

class _ProfileDetailViewState extends State<ProfileDetailView> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final vm = context.read<ProfileViewModel>();
        vm.loadUserInfo(); // lấy info mới nhất

      _nameCtrl.text = vm.name ?? "";
      _phoneCtrl.text = vm.phone ?? "";

      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông tin cá nhân"),
        actions: [
          TextButton(
            onPressed: _loading ? null : () => _save(vm),
            child: _loading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text("Lưu", style: TextStyle(fontSize: 16)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Email (readonly)
              TextFormField(
                initialValue: vm.email ?? "",
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 12),

              // Name
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: "Họ và tên",
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return "Vui lòng nhập họ tên";
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Phone
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Số điện thoại",
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return "Vui lòng nhập số điện thoại";
                  if (v.trim().length < 8) return "Số điện thoại chưa đúng";
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save(ProfileViewModel vm) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      // Cần có hàm này trong ProfileViewModel
      await vm.updateUserInfo(
        name: _nameCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã lưu thông tin")),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi lưu thông tin: $e")),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
