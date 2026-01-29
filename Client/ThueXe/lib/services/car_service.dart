import 'package:dio/dio.dart';
import 'api_service.dart';

class CarService {
  final ApiService _api = ApiService();

  Future<void> updateCarLocation({
    required int carId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      await _api.put(
        "/cars/$carId/location",
        {"latitude": latitude, "longitude": longitude},
      );
    } on DioException catch (e) {
      print("CarService.updateCarLocation: ${e.response?.statusCode} - ${e.response?.data ?? e.message}");
      rethrow;
    }
  }
}
