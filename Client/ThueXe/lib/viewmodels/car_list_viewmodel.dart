import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

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
    required String city, // Nếu = "NEAR_ME" thì tìm gần đây
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

      print("🔍 Searching... Input: '$city'");
      print("🚗 Total cars fetched: ${allCars.length}");

      List<dynamic> filteredCars = [];

      if (city == "NEAR_ME") {
        // --- CÁCH 1: Tìm kiếm theo bán kính 10km ---
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        print("📍 My Location: ${position.latitude}, ${position.longitude}");

        // Sử dụng Future.wait để xử lý song song (nhanh hơn loop)
        // Tuy nhiên với Google Geocoding free tier, quá nhanh có thể bị rate limit. 
        // Ta sẽ dùng loop nhưng handled tốt hơn.
        
        for (var car in allCars) {
           double carLat = (car["latitude"] != null) ? (car["latitude"] as num).toDouble() : 0.0;
           double carLong = (car["longitude"] != null) ? (car["longitude"] as num).toDouble() : 0.0;
           String carAddress = car["location"]?.toString() ?? "";

           // Logic: Nếu chưa có Lat/Long, CỐ GẮNG lấy từ Address
           if (carLat == 0 && carLong == 0 && carAddress.isNotEmpty) {
              try {
                // Clean address: bỏ các ký tự lạ hoặc "Khu vực không hỗ trợ" thừa
                String cleanAddress = carAddress.replaceAll(RegExp(r'\(.*?\)'), '').trim(); // Bỏ phần trong ngoặc
                
                print("🌍 Geocoding address: '$cleanAddress' (Original: '$carAddress')");
                List<Location> locations = await locationFromAddress(cleanAddress);
                
                if (locations.isNotEmpty) {
                  carLat = locations.first.latitude;
                  carLong = locations.first.longitude;
                  print("   -> Found: $carLat, $carLong");
                }
              } catch (e) {
                print("⚠️ Geocoding failed for car ${car["carID"]}: $e");
              }
           }
           
           if (carLat == 0 && carLong == 0) {
             print("❌ Skip car ${car["carID"]} - No GPS data");
             continue; 
           }

           double distanceInMeters = Geolocator.distanceBetween(
             position.latitude, position.longitude, carLat, carLong
           );
           
           print("📏 Distance to car ${car["carID"]}: ${distanceInMeters.toStringAsFixed(1)}m");

           if (distanceInMeters <= 10000) { // 10km
             filteredCars.add(car);
           }
        }
      } else {
        // --- CÁCH 2: Tìm kiếm theo Khu vực ---
        filteredCars = allCars.where((car) {
          final carLocation = car["location"]?.toString().trim().toLowerCase() ?? "";
          final selectedCity = city.trim().toLowerCase();
          return carLocation.contains(selectedCity);
        }).toList();
      }

      cars = filteredCars;
      
      print("✅ Cars after filter: ${cars.length}");

    } catch (e) {
      errorMessage = "Không thể tải hoặc định vị: $e";
      print(e);
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
