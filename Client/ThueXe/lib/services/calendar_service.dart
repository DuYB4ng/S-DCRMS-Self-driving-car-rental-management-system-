import 'package:dio/dio.dart';
import 'api_service.dart';

class CalendarService {
  final ApiService _api = ApiService();

  Future<List<dynamic>> fetchCalendar(int carId) async {
    try {
      final response = await _api.get("/calendar/$carId");
      if (response.statusCode == 200) {
        return response.data as List<dynamic>;
      }
      return [];
    } catch (e) {
      print("Fetch Calendar error: $e");
      return [];
    }
  }

  Future<bool> blockDate(int carId, DateTime date) async {
    try {
      final response = await _api.post("/calendar/block", {
        "carId": carId,
        "date": date.toIso8601String(),
      });
      return response.statusCode == 200;
    } catch (e) {
      print("Block Date error: $e");
      return false;
    }
  }

  Future<bool> unblockDate(int carId, DateTime date) async {
    try {
      final response = await _api.post("/calendar/unblock", {
        "carId": carId,
        "date": date.toIso8601String(),
      });
      return response.statusCode == 200;
    } catch (e) {
      print("Unblock Date error: $e");
      return false;
    }
  }
}
