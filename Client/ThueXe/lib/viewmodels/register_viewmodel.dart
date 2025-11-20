import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> register(String email, String phone, String pass, String rePass) async {
    errorMessage = null;

    // Validate
    if (email.isEmpty || phone.isEmpty || pass.isEmpty || rePass.isEmpty) {
      errorMessage = "Vui lòng nhập đầy đủ thông tin";
      notifyListeners();
      return false;
    }

    if (pass != rePass) {
      errorMessage = "Mật khẩu không trùng khớp";
      notifyListeners();
      return false;
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
      errorMessage = "Đăng ký thất bại! Tài khoản có thể đã tồn tại.";
      notifyListeners();
      return false;
    }

    notifyListeners();
    return true;
  }
}
