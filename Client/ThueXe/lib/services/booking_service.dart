import 'package:dio/dio.dart';
import 'api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingService {
  final ApiService api = ApiService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Response> createBooking({
    required int carId,
    required DateTime receiveDate,
    required DateTime returnDate,
    required int totalPrice,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    final uid = user.uid;

    return await api.post(
      "/booking",
      {
        "startDate": receiveDate.toIso8601String(),
        "endDate": returnDate.toIso8601String(),
        "carId": carId,
        "totalPrice": totalPrice,
      },
      // 👉 gửi firebaseUid lên link
      queryParameters: {"firebaseUid": uid},
    );
  }

  Future<Response> getMyBookings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    final uid = user.uid;

    return await api.get("/booking/my", queryParameters: {"firebaseUid": uid});
  }

  Future<Response> cancelBooking(int bookingId) async {
    return await api.post("/booking/$bookingId/cancel", {});
  }

  Future<Response> confirmReturn(int bookingId) async {
    return await api.post("/booking/$bookingId/confirm-return", {});
  }
  
  Future<Response> checkIn(int bookingId) async {
     final user = FirebaseAuth.instance.currentUser;
     return await api.post("/booking/$bookingId/check-in", {}, queryParameters: {"firebaseUid": user?.uid});
  }
  
  Future<Response> requestCheckOut(int bookingId) async {
     final user = FirebaseAuth.instance.currentUser;
     return await api.post("/booking/$bookingId/request-check-out", {}, queryParameters: {"firebaseUid": user?.uid});
  }

  Future<Response> getBookingsByCarId(int carId) async {
    return await api.get("/booking/car/$carId");
  }
}
