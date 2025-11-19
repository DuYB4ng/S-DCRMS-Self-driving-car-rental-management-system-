import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? errorMessage;

  Future<void> register(String email, String phone, String pass, String rePass) async {
    errorMessage = null;

    if (email.isEmpty || phone.isEmpty || pass.isEmpty || rePass.isEmpty) {
      errorMessage = "Vui lòng nhập đầy đủ thông tin";
      notifyListeners();
      return;
    }

    if (pass != rePass) {
      errorMessage = "Mật khẩu không trùng khớp";
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    final success = await _authService.register(
      email: email,
      phone: phone,
      password: pass,
    );

    isLoading = false;
    if (!success) {
      errorMessage = "Đăng ký thất bại!";
    }

    notifyListeners();
  }
}
