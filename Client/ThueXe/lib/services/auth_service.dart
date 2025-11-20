import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> register({
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      // Đăng ký tài khoản
      UserCredential user = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Lưu thêm số điện thoại vào Firebase User (optional)
      await user.user?.updateDisplayName(phone);

      return true;
    } on FirebaseAuthException catch (e) {
      print("Firebase Register Error: ${e.code} - ${e.message}");
      return false;
    } catch (e) {
      print("Unexpected error: $e");
      return false;
    }
  }
}
