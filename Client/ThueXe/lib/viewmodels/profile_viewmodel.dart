import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import '../services/api_service.dart';

class ProfileViewModel extends ChangeNotifier {
  String? name;
  String? email;
  String? phone;
  String? photoUrl;
  
  bool isLoading = false;

  final _auth = FirebaseAuth.instance;
  final ApiService _api = ApiService();

  // License fields
  String? licenseNo;
  String? licenseIssueDate;
  String? licenseExpiryDate;
  int? customerId;

  // AI Service URL (Direct)
  final String aiServiceUrl = "http://192.168.1.4:8002/ocr-license";

  Future<void> loadUserInfo() async {
    final user = _auth.currentUser;

    if (user != null) {
      email = user.email;
      phone = user.phoneNumber; 
      name = user.displayName; 
      photoUrl = user.photoURL;
      
      // Fetch details from backend
      await _fetchCustomerData(user.uid);
    }
    notifyListeners();
  }

  Future<void> _fetchCustomerData(String uid) async {
    try {
      final res = await _api.get("/customer/by-firebase/$uid");
      if (res.statusCode == 200) {
        final data = res.data;
        customerId = data['customerId'];
        licenseNo = data['drivingLicense'];
        
        // Parse dates if they exist (assuming ISO format from backend)
        if (data['licenseIssueDate'] != null) {
          licenseIssueDate = _formatDate(data['licenseIssueDate']); 
        }
        if (data['licenseExpiryDate'] != null) {
          licenseExpiryDate = _formatDate(data['licenseExpiryDate']);
        }
      }
    } catch (e) {
      print("Error fetching customer data: $e");
    }
  }
  
  String _formatDate(String isoString) {
    try {
      if (isoString.startsWith('0001')) return ""; // Default/Empty date
      final date = DateTime.parse(isoString);
      return "${date.day}/${date.month}/${date.year}";
    } catch (_) {
      return "";
    }
  }

  // ===== SCAN LICENSE (AI) =====
  Future<Map<String, String>?> scanLicense(File imageFile) async {
    isLoading = true;
    notifyListeners();
    
    try {
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
           imageFile.path, 
           filename: fileName,
           contentType: MediaType('image', 'jpeg')
        ),
      });

      final res = await _api.postExternal(
        aiServiceUrl, 
        formData, 
        options: Options(
           headers: {"Content-Type": "multipart/form-data"},
           receiveTimeout: const Duration(seconds: 60)
        )
      );

      if (res.statusCode == 200) {
        final data = res.data;
        // AI returns: license_no, expiry_date (dd/mm/yyyy), raw_text
        return {
          "licenseNo": data['license_no'] ?? "",
          "expiryDate": data['expiry_date'] ?? "",
          // Note: issue_date logic in AI might be missing or merged, we can infer or ask user
          "issueDate": "" 
        };
      }
    } catch (e) {
      print("OCR Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return null;
  }

  // ===== UPDATE INFO (Include License) =====
  Future<void> updateAllInfo({
      required String newName, 
      required String newLicenseNo,
      required String newIssueDate, // format dd/mm/yyyy
      required String newExpiryDate // format dd/mm/yyyy
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;
    
    isLoading = true;
    notifyListeners();
    
    try {
      // 1. Update Firebase Name
      if (newName != name) {
        await user.updateDisplayName(newName);
        await user.reload();
      }

      // 2. Update Backend Customer Info (License)
      if (customerId != null) {
        // Convert dd/mm/yyyy to ISO
        final issueIso = _toIsoDate(newIssueDate);
        final expiryIso = _toIsoDate(newExpiryDate);

        await _api.put("/customer/$customerId", {
          "customerId": customerId,
          "firebaseUid": user.uid,
          "drivingLicense": newLicenseNo,
          "licenseIssueDate": issueIso,
          "licenseExpiryDate": expiryIso
        });
      }
      
      await loadUserInfo(); // Reload all
    } catch (e) {
      print("Error updating profile: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  
  String _toIsoDate(String dmy) {
    // dmy: dd/mm/yyyy
    try {
      final parts = dmy.split('/');
      if (parts.length == 3) {
         return "${parts[2]}-${parts[1]}-${parts[0]}T00:00:00Z";
      }
    } catch (_) {}
    return DateTime.now().toIso8601String(); // Fallback
  }

  // ... keep updateName and uploadAvatar ...
  Future<void> updateName(String newName) async {
     // ... legacy simple method, can be kept ...
      final user = _auth.currentUser;
      if (user != null) await user.updateDisplayName(newName);
      notifyListeners();
  }

  Future<void> uploadAvatar(File imageFile) async {
    final user = _auth.currentUser;
    if (user == null) return;

    isLoading = true;
    notifyListeners();

    try {
      String fileName = imageFile.path.split('/').last;
      
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
          contentType: MediaType('image', 'jpeg'),
        ),
      });

      // 1. Upload to Server via Gateway
      final response = await _api.uploadImage("/upload", formData);
      
      if (response.statusCode == 200) {
        // 2. Get relative URL from server (e.g., "/images/abc.jpg")
        String relativeUrl = response.data['url'];
        
        // 3. Construct full URL via Gateway
        String fullUrl = "http://192.168.1.4:8000$relativeUrl";
        
        // 4. Update Firebase Profile
        await user.updatePhotoURL(fullUrl);
        await user.reload();
        loadUserInfo();
      }
    } catch (e) {
      print("Error uploading avatar: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
