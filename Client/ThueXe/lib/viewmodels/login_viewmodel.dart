import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';
import '../services/tracking_manager.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();
  final TrackingManager _tracking = TrackingManager();

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
      final user = userCredential.user;
      if (user == null) {
        throw FirebaseAuthException(code: 'user-null', message: 'User is null');
      }

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


      // 4) ✅ Start GPS tracking (KHÔNG để lỗi làm fail login)
      // distanceFilter owner nhỏ hơn để tracking mượt hơn
      final filter = (role ?? "").toLowerCase().contains("owner") ? 30 : 50;

      // QUAN TRỌNG: không await bắt buộc cũng được
      // nhưng bạn đang muốn chạy ngay sau login thì await vẫn ok,
      // miễn là TrackingManager/UserService có try/catch không throw.
      await _tracking.startForUser(
        firebaseUid: user.uid,
        distanceFilter: filter,
      );

      // setLoading(false);
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
    } finally {
    setLoading(false);
    }
  }

    Future<void> logout() async {
      try {
        // 1) dừng GPS tracking
        await _tracking.stop();

        // 2) logout firebase
        await FirebaseAuth.instance.signOut();

        // 3) clear state nếu muốn
        role = null;
        errorMessage = null;
      } catch (e) {
        print("logout error: $e");
      } finally {
        notifyListeners();
      }
  }

    void attachActiveCar(int carId) {
    _tracking.attachCar(carId);
  }

    void detachActiveCar() {
      _tracking.detachCar();
  }
}
