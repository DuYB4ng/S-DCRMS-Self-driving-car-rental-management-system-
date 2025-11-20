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
}
