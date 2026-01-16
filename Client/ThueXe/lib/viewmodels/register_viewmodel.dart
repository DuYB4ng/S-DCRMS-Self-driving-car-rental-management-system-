import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../services/customer_service.dart';

import 'package:firebase_auth/firebase_auth.dart';
import '../services/owner_service.dart';

class RegisterViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instance of FirebaseAuth
  final AuthService _authService = AuthService();
  final CustomerService _customerService = CustomerService();
  final OwnerService _ownerService = OwnerService(); // Instance of OwnerService

  bool isLoading = false;
  String? errorMessage;
  String selectedRole = "Customer";

  void setRole(String role) {
    selectedRole = role;
    notifyListeners();
  }

  Future<bool> register(
    String email,
    String displayName,
    String pass,
    String rePass,
    String role,
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

    // 1. Call AuthService to register (Backend)
    final uid = await _authService.register(
      email: email,
      displayName: displayName,
      password: pass,
      role: role,
    );

    if (uid == null) {
      isLoading = false;
      errorMessage = "Đăng ký thất bại. Vui lòng thử lại.";
      notifyListeners();
      return false;
    }

    // 2. Auto Login with Firebase (Client side)
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: pass);
    } on FirebaseAuthException catch (e) {
      print("Auto-login failed: ${e.message}");
      // Even if auto-login fails, account might be created. 
      // But for UX, we treat it as part of the flow.
      isLoading = false;
      errorMessage = "Đăng ký thành công nhưng đăng nhập thất bại: ${e.message}";
      notifyListeners();
      return false;
    }

    // 3. Create Profile (Customer or Owner) based on selected role
    try {
      if (role == "OwnerCar") {
        await _ownerService.createOwner(firebaseUid: uid);
      } else {
        await _customerService.createCustomer(firebaseUid: uid);
      }
    } catch (e) {
      print("Create profile failed: $e");
      // Optional: Handle error, maybe retry or show warning
    }

    isLoading = false;
    notifyListeners();
    return true;
  }
}
