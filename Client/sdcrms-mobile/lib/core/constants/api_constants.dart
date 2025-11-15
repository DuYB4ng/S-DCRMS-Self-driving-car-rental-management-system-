class ApiConstants {
  // Base URLs
  static const String baseUrl = 'http://10.0.2.2:5100'; // Android Emulator
  // static const String baseUrl = 'http://localhost:5100'; // iOS Simulator
  // static const String baseUrl = 'http://192.168.1.x:5100'; // Physical Device
  
  // Endpoints
  static const String adminEndpoint = '/api/admin';
  static const String notificationEndpoint = '/api/notification';
  static const String authEndpoint = '/api/auth';
  
  // Full URLs
  static String get adminUrl => '$baseUrl$adminEndpoint';
  static String get notificationUrl => '$baseUrl$notificationEndpoint';
  static String get authUrl => '$baseUrl$authEndpoint';
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
