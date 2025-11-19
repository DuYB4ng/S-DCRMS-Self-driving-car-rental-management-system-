import 'package:flutter/material.dart';
import '../services/api_service.dart';

class OrdersViewModel extends ChangeNotifier {
  final ApiService api = ApiService();

  bool isLoading = false;
  List<dynamic> orders = [];
  String? errorMessage;
  bool isLoadedOnce = false;

  // 👉 Lần đầu mở trang (chỉ load 1 lần)
  Future<void> loadOrders() async {
    if (isLoadedOnce) return;

    isLoadedOnce = true;
    return refreshOrders(); // dùng cơ chế load mới
  }

  // 👉 Load lại dữ liệu mỗi lần người dùng yêu cầu (ấn nút, quay lại màn hình, ...)
  Future<void> refreshOrders() async {
    isLoading = true;
    notifyListeners();

    try {
      final res = await api.get("/booking");
      orders = res.data;
      errorMessage = null;
    } catch (e) {
      errorMessage = "Không thể tải danh sách đơn hàng.";
    }

    isLoading = false;
    notifyListeners();
  }

  // 👉 Pull-to-refresh khi dùng RefreshIndicator
  Future<void> pullToRefresh() async {
    try {
      final res = await api.get("/booking");
      orders = res.data;
      errorMessage = null;
    } catch (e) {
      errorMessage = "Không thể tải danh sách đơn hàng.";
    }

    notifyListeners();
  }
}
