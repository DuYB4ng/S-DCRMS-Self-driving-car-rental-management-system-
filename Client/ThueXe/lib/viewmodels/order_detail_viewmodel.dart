import 'package:flutter/material.dart';
import '../services/api_service.dart';

class OrderDetailViewModel extends ChangeNotifier {
  final ApiService api = ApiService();

  bool isLoading = false;
  Map<String, dynamic>? orderData;
  String? errorMessage;

  // 👉 Load lần đầu (khi mở trang)
  Future<void> loadOrder(String orderId) async {
    isLoading = true;
    notifyListeners();

    await _fetchOrder(orderId);

    isLoading = false;
    notifyListeners();
  }

  // 👉 Reload khi vuốt để tải lại (pull to refresh)
  Future<void> pullToRefresh(String orderId) async {
    await _fetchOrder(orderId);
    notifyListeners();
  }

  // 👉 Reload khi quay lại màn Orders
  Future<void> refreshOrder(String orderId) async {
    await _fetchOrder(orderId);
    notifyListeners();
  }

  // ============================
  // 🔧 Hàm dùng chung để gọi API
  // ============================
  Future<void> _fetchOrder(String orderId) async {
    try {
      final res = await api.get("/booking/$orderId");
      orderData = res.data;
      errorMessage = null;
    } catch (e) {
      errorMessage = "Không thể tải đơn hàng.";
    }
  }
}
