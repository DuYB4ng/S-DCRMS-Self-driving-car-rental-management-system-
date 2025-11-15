import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      //thay api
      baseUrl: "https://your-gateway.com/api",
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
    ),
  );

  // POST
  Future<Response> post(String path, Map<String, dynamic> data) async {
    return await _dio.post(path, data: data);
  }

  // GET
  Future<Response> get(String path) async {
    return await _dio.get(path);
  }
}
