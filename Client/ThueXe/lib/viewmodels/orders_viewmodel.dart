import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/booking_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrdersViewModel extends ChangeNotifier {
  // Dùng BookingService để lấy danh sách booking của customer
  final BookingService bookingService = BookingService();

  // Vẫn giữ ApiService cho các action check-in / check-out
  final ApiService api = ApiService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;
  List<dynamic> orders = [];
  String? errorMessage;
  bool isLoadedOnce = false;

  // 👉 Lần đầu mở trang (chỉ load 1 lần)
  Future<void> loadOrders() async {
    if (isLoadedOnce) return;

    isLoadedOnce = true;
    await refreshOrders();
  }

  // 👉 Load lại dữ liệu mỗi lần người dùng yêu cầu (ấn nút, quay lại màn hình, ...)
  Future<void> refreshOrders() async {
    isLoading = true;
    notifyListeners();

    try {
      // CHỈ lấy booking của customer hiện tại
      final res = await bookingService.getMyBookings();
      orders = res.data;
      errorMessage = null;
    } catch (e) {
      errorMessage = "Không thể tải danh sách đơn hàng.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// CUSTOMER check-in booking
  Future<void> checkIn(int bookingId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      final uid = user.uid;

      print("CALLING CHECK-IN: /booking/$bookingId/check-in?firebaseUid=$uid");
      final res = await api.post(
        "/booking/$bookingId/check-in",
        {},
        queryParameters: {
          "firebaseUid": uid,
        },
      );
      print("CHECK-IN RESPONSE: $res");

      await refreshOrders();
    } catch (e) {
      print("CHECK-IN ERROR: $e");
      rethrow;
    }
  }

  /// CUSTOMER REQUEST check-out (Request Return)
  Future<void> requestCheckOut(int bookingId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      final uid = user.uid;

      await api.post(
        "/booking/$bookingId/request-check-out",
        {},
        queryParameters: {
          "firebaseUid": uid,
        },
      );

      await refreshOrders();
    } catch (e) {
      rethrow;
    }
  }
}
