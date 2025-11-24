import 'package:dio/dio.dart';
import 'api_service.dart';

class BookingService {
  final ApiService api = ApiService();

  Future<Response> createBooking({
    required int carId,
    required DateTime receiveDate,
    required DateTime returnDate,
    required int totalPrice,
  }) async {
    return await api.post("/Booking", {
      "startDate": receiveDate.toIso8601String(),
      "endDate": returnDate.toIso8601String(),
      "carId": carId,
      "totalPrice": totalPrice,
    });
  }
}
