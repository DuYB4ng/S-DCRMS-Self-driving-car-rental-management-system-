import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileViewModel extends ChangeNotifier {
  String? name;
  String? email;
  String? phone;

  final _auth = FirebaseAuth.instance;

  void loadUserInfo() {
    final user = _auth.currentUser;

    if (user != null) {
      email = user.email;
      phone = user.displayName;   // bạn đã lưu phone vào displayName khi đăng ký
      name = user.displayName;    // hoặc nếu sau này bạn lưu tên thật
    }
    notifyListeners();
  }

   /// ✅ Update thông tin cá nhân (Name + Phone)
  Future<void> updateUserInfo({
    required String name,
    required String phone,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    // ⚠️ FirebaseAuth chỉ có displayName
    // Tạm thời lưu phone chung với name (giống logic hiện tại của bạn)
    await user.updateDisplayName(name);

    // Reload user từ Firebase
    await user.reload();

    // Cập nhật lại state
    this.name = name;
    this.phone = phone;
    this.email = user.email;

    notifyListeners();
  }
}
