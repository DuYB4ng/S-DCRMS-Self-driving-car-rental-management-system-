import 'package:dio/dio.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _api = ApiService();

  /// Gọi API AuthService /api/auth/signup để đăng ký user
  /// Trả về firebaseUid (uid) nếu thành công, null nếu thất bại
  Future<String?> register({
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _api.post("/auth/signup", {
        "email": email,
        "password": password,
        "confirmPassword": password,
        "displayName": phone, // tạm thời dùng số điện thoại làm displayName
      });

      final data = response.data;
      if (data is Map<String, dynamic> && data["uid"] != null) {
        return data["uid"] as String;
      }

      print("AuthService.register: response không có uid: $data");
      return null;
    } on DioException catch (e) {
      print(
        "AuthService.register DioError: ${e.response?.statusCode} - ${e.response?.data ?? e.message}",
      );
      return null;
    } catch (e) {
      print("AuthService.register unexpected error: $e");
      return null;
    }
  }
}
