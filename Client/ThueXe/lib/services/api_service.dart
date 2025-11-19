import 'package:dio/dio.dart';

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

  Future<Response> post(String path, Map<String, dynamic> data) async {
    return await _dio.post(path, data: data);
  }

  Future<Response> get(String path) async {
    return await _dio.get(path);
  }
}
