import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CarListViewModel extends ChangeNotifier {
  final ApiService api = ApiService();

  bool isLoading = false;
  String? errorMessage;

  List<dynamic> cars = [];

  bool loadedOnce = false;  // ✔ CHẶN LOAD LẶP

  Future<void> searchCars({
    required String city,
    required DateTime receiveDate,
    required TimeOfDay receiveTime,
    required DateTime returnDate,
    required TimeOfDay returnTime,

  }) async {

    if (loadedOnce) return; // ✔ Không load lại
    loadedOnce = true;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final res = await api.post("/cars/search", {
        "city": city,
        "receiveDate": receiveDate.toIso8601String(),
        "receiveTime": receiveTime.format24h(),
        "returnDate": returnDate.toIso8601String(),
        "returnTime": returnTime.format24h(),
      });

      cars = res.data; // ✔ dữ liệu từ API
    } catch (e) {
      errorMessage = "Không thể tải dữ liệu xe";
    }

    isLoading = false;
    notifyListeners();
  }
}

/// ✔ CORRECT: extension phải đặt ngoài class
extension TimeFormat on TimeOfDay {
  String format24h() {
    return "${hour.toString().padLeft(2, "0")}:${minute.toString().padLeft(2, "0")}";
  }
}
