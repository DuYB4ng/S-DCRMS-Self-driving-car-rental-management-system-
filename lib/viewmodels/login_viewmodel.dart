import 'package:flutter/material.dart';
import '../services/api_service.dart';


class LoginViewModel extends ChangeNotifier {
  final ApiService api = ApiService();

  bool isLoading = false;
  String? errorMessage;
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
  Future<bool> login(String email, String password) async {
    // errorMessage = null;
    //
    // if (email.isEmpty || password.isEmpty) {
    //   errorMessage = "Vui lòng nhập đầy đủ thông tin";
    //   notifyListeners();
    //   return false;
    // }
    //
    // isLoading = true;
    // notifyListeners();
    //
    // try {
    //   final res = await api.post("/auth/login", {
    //     "email": email,
    //     "password": password,
    //   });
    //
    //   print("API Login Result: ${res.data}");
    //
    //   isLoading = false;
    //   notifyListeners();
    //   return true;
    // } catch (e) {
    //   isLoading = false;
    //   errorMessage = "Sai email hoặc mật khẩu!";
    //   notifyListeners();
    //   return false;
    // }
    return true;
  }
}
