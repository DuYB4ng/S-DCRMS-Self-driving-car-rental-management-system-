import 'package:dio/dio.dart';
import 'api_service.dart';

class CustomerService {
  final ApiService _api = ApiService();

  /// Tạo customer cho user mới đăng ký
  Future<Response> createCustomer({required String firebaseUid}) async {
    return await _api.post("/customer", {
      "firebaseUid": firebaseUid,

      // Tạm để trống, sau này có màn cập nhật thông tin thì update sau
      "drivingLicense": "",
      "licenseIssueDate": DateTime.now().toIso8601String(),
      "licenseExpiryDate": DateTime.now()
          .add(const Duration(days: 3650))
          .toIso8601String(),
    });
  }
}
