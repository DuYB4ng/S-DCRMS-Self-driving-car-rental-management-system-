import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? errorMessage;
  String? role; // Store the user role

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
      // 1. Firebase Login
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      // 2. Get ID Token
      final idToken = await userCredential.user?.getIdToken();
      if (idToken == null) {
        throw FirebaseAuthException(code: 'token-error', message: 'Cannot get ID Token');
      }

      // 3. Verify with Backend
      final data = await _authService.verifyToken(idToken);
      if (data == null) {
         throw FirebaseAuthException(code: 'backend-error', message: 'Verification failed');
      }
      
      role = data['role'];

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
