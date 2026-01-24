import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'api_service.dart';

class SmartCheckInService {
  final ApiService _api = ApiService();
  
  // AI Service runs on port 8002, use local IP
  final String aiServiceUrl = "http://192.168.111.150:8002/detect";

  Future<Map<String, dynamic>?> analyzeImage(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;
      
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
          contentType: MediaType('image', 'jpeg'), // Adjust if png
        ),
      });

      // Call directly to AI Service
      final response = await _api.postExternal(
        aiServiceUrl,
        formData,
        options: Options(
            headers: { "Content-Type": "multipart/form-data" },
            sendTimeout: const Duration(seconds: 60), 
            receiveTimeout: const Duration(seconds: 60)
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {
      print("AI Service Error: $e");
      return null;
    }
  }
}
