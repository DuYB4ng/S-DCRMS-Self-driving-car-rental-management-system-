import 'package:dio/dio.dart';
import 'api_service.dart';

class PaymentService {
  final ApiService api = ApiService();

  Future<Response> createCashPayment({
    required int bookingId,
    required int amount,
  }) async {
    return await api.post("/payment", {
      "paymentDate": DateTime.now().toIso8601String(),
      "amount": amount,
      "method": "Cash",
      "status": "Completed",
      "bookingID": bookingId,
    });
  }

  Future<Response> createVnPayPayment({
    required int bookingId,
    required int amount,
  }) async {
    return await api.post("/payment/create-vnpay", {
      "bookingId": bookingId,
      "amount": amount,
    });
  }

  Future<Response> getPaymentById(int id) async {
    return await api.get("/payment/$id");
  }

  Future<String> retryVnPay(int bookingId) async {
    final res = await api.post("/payment/vnpay/retry/$bookingId", {});
    return res.data["url"] as String;
  }
}
