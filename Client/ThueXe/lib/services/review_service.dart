import 'package:dio/dio.dart';

import 'api_service.dart';

class ReviewService {
  final ApiService _api = ApiService();

  /// Tạo review cho một booking
  Future<Response> createReview({
    required int bookingId,
    required int rating,
    required String comment,
  }) {
    return _api.post("/review", {
      "bookingID": bookingId,
      "rating": rating,
      "comment": comment,
    });
  }

  /// Lấy danh sách review theo car
  Future<Response> getReviewsByCar(int carId) {
    return _api.get("/review/car/$carId");
  }
}
