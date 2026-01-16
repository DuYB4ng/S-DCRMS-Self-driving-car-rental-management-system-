import 'package:dio/dio.dart';
import 'api_service.dart';

class OwnerService {
  final ApiService _api = ApiService();

  /// Create owner profile for new user
  Future<Response> createOwner({required String firebaseUid}) async {
    return await _api.post("/ownercar", {
      "firebaseUid": firebaseUid,
      
      // Default placeholder data
      "DrivingLicence": "",
      "LicenceIssueDate": DateTime.now().toIso8601String(),
      "LicenceExpiryDate": DateTime.now().add(const Duration(days: 3650)).toIso8601String(),
    });
  }
}
