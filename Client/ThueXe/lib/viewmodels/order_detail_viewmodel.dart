import 'package:flutter/material.dart';
import '../services/api_service.dart';

class OrderDetailViewModel extends ChangeNotifier {
  final ApiService api = ApiService();

  bool isLoading = false;
  Map<String, dynamic>? orderData;
  Map<String, dynamic>? carData;
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
      // 1️⃣ Lấy thông tin booking
      final res = await api.get("/booking/$orderId");
      orderData = res.data;
      errorMessage = null;

      // 2️⃣ Dựa vào carId trong booking để gọi thêm thông tin xe
      carData = null; // reset
      final carId = orderData?["carId"];
      if (carId != null) {
        try {
          final carRes = await api.get("/Car/$carId");
          carData = carRes.data;
        } catch (_) {
          // Nếu lỗi lấy xe thì vẫn hiển thị hóa đơn, chỉ là không có block thông tin xe
          carData = null;
        }
      }

      notifyListeners(); // thông báo UI cập nhật dữ liệu mới
    } catch (e) {
      errorMessage = "Không thể tải đơn hàng.";
      notifyListeners();
    }
  }
}
