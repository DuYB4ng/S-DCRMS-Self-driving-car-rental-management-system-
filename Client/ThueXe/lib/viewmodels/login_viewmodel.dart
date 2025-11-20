import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;
  String? errorMessage;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      errorMessage = "Vui lòng nhập đầy đủ thông tin";
      notifyListeners();
      return false;
    }

    setLoading(true);

    try {
      await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      setLoading(false);

      if (e.code == 'user-not-found') {
        errorMessage = "Không tìm thấy tài khoản!";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Sai mật khẩu!";
      } else {
        errorMessage = "Lỗi đăng nhập: ${e.message}";
      }

      notifyListeners();
      return false;
    }
  }
}
