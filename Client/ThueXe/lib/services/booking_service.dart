import 'package:dio/dio.dart';
import 'api_service.dart';

class BookingService {
  final ApiService api = ApiService();

  Future<Response> createBooking({
    required int carId,
    required DateTime receiveDate,
    required DateTime returnDate,
    required double totalPrice,
  }) async {
    return await api.post(
      "/Booking",
      {
        "carID": carId,
        "receiveDate": receiveDate.toIso8601String(),
        "returnDate": returnDate.toIso8601String(),
        "totalPrice": totalPrice,
      },
    );
  }
}
