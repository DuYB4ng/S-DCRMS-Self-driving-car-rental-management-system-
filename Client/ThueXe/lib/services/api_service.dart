import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://192.168.100.5:8000/api",
      connectTimeout: Duration(seconds: 8),
      receiveTimeout: Duration(seconds: 8),
    ),
  );

  ApiService() {
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  /// Lấy Firebase ID Token
  Future<String?> _getFirebaseToken() async {
    return await FirebaseAuth.instance.currentUser?.getIdToken();
  }

  /// GET request có token
  Future<Response> get(String path) async {
    final token = await _getFirebaseToken();

    return await _dio.get(
      path,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
  }

  /// POST request có token
  Future<Response> post(String path, Map<String, dynamic> data) async {
    final token = await _getFirebaseToken();

    return await _dio.post(
      path,
      data: data,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
  }
}
