import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CarListViewModel extends ChangeNotifier {
  final ApiService api = ApiService();
  String get baseUrl => api.baseUrl;

  bool isLoading = false;
  String? errorMessage;

  List<dynamic> cars = [];

  /// ============================
  ///  SEARCH CARS THEO YÊU CẦU
  /// ============================
  Future<void> searchCars({
    required String city,
    required DateTime receiveDate,
    required TimeOfDay receiveTime,
    required DateTime returnDate,
    required TimeOfDay returnTime,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // 🔥 Gọi API lấy toàn bộ xe
      final res = await api.get("/Car/available");
      final List<dynamic> allCars = res.data;

      print("🔍 Searching for city: '$city'");
      print("🚗 Total cars fetched: ${allCars.length}");

      // 🔥 Lọc thành phố (location)
      cars = allCars.where((car) {
        final carCity = car["location"]?.toString().trim().toLowerCase();
        final selectedCity = city.trim().toLowerCase();
        
        // Debug filtering
        if (carCity != selectedCity) {
          print("❌ Filtered out car ${car["carID"]}: Location '$carCity' != '$selectedCity'");
        }
        
        return carCity == selectedCity;
      }).toList();

      // 🔥 (Tùy chọn) Lọc trạng thái xe còn hoạt động
      cars = cars.where((car) => car["isAvailable"] == true).toList();
      
      print("✅ Cars after filter: ${cars.length}");

      // Bạn muốn lọc thêm theo ngày nhận / trả?
      // Vì backend chưa có logic booking, flutter KHÔNG biết xe có bị trùng lịch
      // nên mình chỉ lọc theo thành phố + isAvailable là đủ
    } catch (e) {
      errorMessage = "Không thể tải danh sách xe";
    }

    isLoading = false;
    notifyListeners();
  }

  /// ============================
  ///  LẤY TẤT CẢ XE (nếu cần)
  /// ============================
  Future<void> loadCars() async {
    isLoading = true;
    notifyListeners();

    try {
      final res = await api.get("/Car/available");
      cars = res.data;
    } catch (e) {
      errorMessage = "Không thể tải danh sách xe";
    }

    isLoading = false;
    notifyListeners();
  }
}
