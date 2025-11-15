import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import '../constants/api_constants.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  
  late Dio _dio;
  final Logger _logger = Logger();
  
  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    
    // Request Interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _logger.d('REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          _logger.d(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (error, handler) {
          _logger.e(
            'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
          );
          return handler.next(error);
        },
      ),
    );
  }
  
  Dio get dio => _dio;
  
  // Helper methods
  Future<Response> get(String path) async {
    return await _dio.get(path);
  }
  
  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }
  
  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }
  
  Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }
}
