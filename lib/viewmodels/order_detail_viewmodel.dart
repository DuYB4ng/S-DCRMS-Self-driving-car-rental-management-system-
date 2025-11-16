import 'package:flutter/material.dart';
import '../services/api_service.dart';

class OrderDetailViewModel extends ChangeNotifier {
  final ApiService api = ApiService();

  bool isLoading = false;
  Map<String, dynamic>? orderData;
  String? errorMessage;

  Future<void> loadOrder(String orderId) async {
    isLoading = true;
    notifyListeners();

    try {
      final res = await api.get("/orders/$orderId");
      orderData = res.data;
      errorMessage = null;
    } catch (e) {
      errorMessage = "Không thể tải đơn hàng";
    }

    isLoading = false;
    notifyListeners();
  }
}
