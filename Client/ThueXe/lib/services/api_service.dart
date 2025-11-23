import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://192.168.1.29:8000/api",
      connectTimeout: Duration(seconds: 8),
      receiveTimeout: Duration(seconds: 8),
    ),
  );

  ApiService() {
    _dio.interceptors.add(
      LogInterceptor(request: true, requestBody: true, responseBody: true),
    );
  }

  /// Lấy Firebase ID Token
  Future<String?> _getFirebaseToken() async {
    return await FirebaseAuth.instance.currentUser?.getIdToken();
  }

  /// ======================
  /// GET (hỗ trợ queryParameters)
  /// ======================
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final token = await _getFirebaseToken();

    return await _dio.get(
      path,
      queryParameters: queryParameters,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  /// ======================
  /// POST
  /// ======================
  Future<Response> post(
    String path,
    Map<String, dynamic> data, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final token = await _getFirebaseToken();

    return await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}
