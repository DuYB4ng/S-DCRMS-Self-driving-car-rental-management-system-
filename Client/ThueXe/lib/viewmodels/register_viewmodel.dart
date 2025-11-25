import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/customer_service.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final CustomerService _customerService = CustomerService();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> register(
    String email,
    String phone,
    String pass,
    String rePass,
  ) async {
    errorMessage = null;

    // ===== Validate cơ bản =====
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

    // ===== 1. Gọi AuthService (backend) để đăng ký =====
    final uid = await _authService.register(
      email: email,
      phone: phone,
      password: pass,
    );

    if (uid == null) {
      isLoading = false;
      errorMessage = "Đăng ký thất bại. Vui lòng thử lại.";
      notifyListeners();
      return false;
    }

    // ===== 2. Tạo Customer tương ứng trong CustomerService =====
    try {
      await _customerService.createCustomer(firebaseUid: uid);
    } catch (e) {
      // Không bắt user đăng ký lại chỉ vì lỗi đồng bộ customer
      print("Create customer failed: $e");
    }

    isLoading = false;
    notifyListeners();
    return true;
  }
}
