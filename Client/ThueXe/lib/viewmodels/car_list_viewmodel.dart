import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CarListViewModel extends ChangeNotifier {
  final ApiService api = ApiService();

  bool isLoading = false;
  String? errorMessage;

  List<dynamic> cars = [];
  bool loadedOnce = false;

  Future<void> loadCars() async {
    if (loadedOnce) return; // tránh gọi lại
    loadedOnce = true;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final res = await api.get("/car");   // ✔ ĐÚNG API
      cars = res.data;
    } catch (e) {
      errorMessage = "Không thể tải danh sách xe";
    }

    isLoading = false;
    notifyListeners();
  }
}
