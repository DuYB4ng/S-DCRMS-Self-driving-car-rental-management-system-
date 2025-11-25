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
    String displayName, // 👈 đổi tên tham số
    String pass,
    String rePass,
  ) async {
    errorMessage = null;

    if (email.isEmpty ||
        displayName.isEmpty ||
        pass.isEmpty ||
        rePass.isEmpty) {
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

    // 1. Gọi AuthService để đăng ký
    final uid = await _authService.register(
      email: email,
      displayName: displayName, // 👈 truyền tên hiển thị
      password: pass,
    );

    if (uid == null) {
      isLoading = false;
      errorMessage = "Đăng ký thất bại. Vui lòng thử lại.";
      notifyListeners();
      return false;
    }

    // 2. Tạo customer
    try {
      await _customerService.createCustomer(firebaseUid: uid);
    } catch (e) {
      print("Create customer failed: $e");
    }

    isLoading = false;
    notifyListeners();
    return true;
  }
}
