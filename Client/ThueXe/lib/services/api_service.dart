import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://192.168.111.150:8000/api",
      connectTimeout: Duration(seconds: 60),
      receiveTimeout: Duration(seconds: 60),
    ),
  );

  ApiService() {
    _dio.interceptors.add(
      LogInterceptor(request: true, requestBody: true, responseBody: true),
    );
  }

  String get baseUrl => _dio.options.baseUrl;

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
  
  /// ======================
  /// PUT
  /// ======================
  Future<Response> put(
    String path,
    Map<String, dynamic> data, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final token = await _getFirebaseToken();

    return await _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
  
  /// ======================
  /// PATCH
  /// ======================
  Future<Response> patch(
    String path,
    Map<String, dynamic> data, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final token = await _getFirebaseToken();

    return await _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  /// ======================
  /// DELETE
  /// ======================
  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final token = await _getFirebaseToken();

    return await _dio.delete(
      path,
      queryParameters: queryParameters,
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }

  /// ======================
  /// POST External (Gọi service khác port, ví dụ AI Service)
  /// ======================
  Future<Response> postExternal(
    String fullUrl,
    dynamic data, {
    Options? options,
  }) async {
    return await _dio.post(
      fullUrl,
      data: data,
      options: options,
    );
  }

  /// ======================
  /// UPLOAD (Multipart)
  /// ======================
  Future<Response> uploadImage(String path, FormData formData) async {
    final token = await _getFirebaseToken();

    return await _dio.post(
      path,
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );
  }
}
