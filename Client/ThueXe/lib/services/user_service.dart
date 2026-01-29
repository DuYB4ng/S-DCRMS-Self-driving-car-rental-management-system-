import 'package:dio/dio.dart';
import 'api_service.dart';

class UserService {
  final ApiService _api = ApiService();

  Future<void> updateUserLocation({
    required String firebaseUid,
    required double latitude,
    required double longitude,
  }) async {
    try {
      await _api.put(
        "/users/firebase/$firebaseUid/location",
        {"latitude": latitude, "longitude": longitude},
      );
    } on DioException catch (e) {
      // log để debug, không làm crash app
      print("UserService.updateUserLocation: ${e.response?.statusCode} - ${e.response?.data ?? e.message}");
      rethrow;
    }
  }
}
