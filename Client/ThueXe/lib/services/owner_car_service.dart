import 'dart:io';
import 'package:dio/dio.dart';
import '../models/car.dart';
import 'api_service.dart';

class OwnerCarService {
  final ApiService _api = ApiService();
  String get baseUrl => _api.baseUrl;

  /// Get owner details including list of cars by Firebase UID
  /// Returns owner data map, including 'cars' list
  Future<Map<String, dynamic>?> getOwnerByUid(String uid) async {
    try {
      final response = await _api.get("/ownercar/by-uid/$uid");
      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } catch (e) {
      print("Error getting owner: $e");
      return null;
    }
  }

  /// Create owner profile if it doesn't exist
  Future<bool> createOwnerProfile(String uid) async {
    try {
      final response = await _api.post("/ownercar", {
        "firebaseUid": uid,
        "DrivingLicence": "N/A",
        "LicenceIssueDate": DateTime.now().toIso8601String(),
        "LicenceExpiryDate": DateTime.now().add(const Duration(days: 3650)).toIso8601String(),
      });
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print("Error creating owner profile: $e");
      return false;
    }
  }

  /// Add a car to the owner's fleet
  Future<Car?> addCar(int ownerId, Car car) async {
    try {
      // Create clean map matching DTO
      final carData = {
        'NameCar': car.nameCar,
        'LicensePlate': car.licensePlate,
        'ModelYear': car.modelYear,
        'Seat': car.seat,
        'TypeCar': car.typeCar,
        'Transmission': car.transmission,
        'FuelType': car.fuelType,
        'FuelConsumption': car.fuelConsumption,
        'Color': car.color,
        'PricePerDay': car.pricePerDay ?? 0.0,
        'Deposit': car.deposit ?? 0.0,
        'Location': car.location,
        'IsActive': car.isActive,
        'OwnershipType': 'Personal', // Default
        'RegistrationDate': DateTime.now().toIso8601String(),
        'RegistrationPlace': 'VN',
        'InsuranceExpiryDate': DateTime.now().add(const Duration(days: 365)).toIso8601String(),
        'InspectionExpiryDate': DateTime.now().add(const Duration(days: 365)).toIso8601String(),
        'Description': car.description,
        'ImageUrls': car.imageUrls,
      };

      final response = await _api.post(
        "/ownercar/$ownerId/cars",
        carData,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return Car.fromJson(response.data);
      }
      return null;
    } catch (e) {
      if (e is DioException) {
        print("Error adding car: ${e.message}");
        print("Response data: ${e.response?.data}");
      } else {
        print("Error adding car: $e");
      }
      rethrow;
    }
  }

  /// Update an existing car
  Future<Car?> updateCar(int carId, Car car) async {
    try {
      final data = car.toJson();
      data['carID'] = carId; 
      final response = await _api.put(
        "/ownercar/cars/$carId",
        data,
      );
      if (response.statusCode == 200) {
        return Car.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("Error updating car: $e");
      rethrow;
    }
  }

  /// Delete a car
  Future<bool> deleteCar(int carId) async {
    try {
      final response = await _api.delete("/ownercar/cars/$carId");
      return response.statusCode == 204 || response.statusCode == 200;
    } catch (e) {
       print("Error deleting car: $e");
       return false;
    }
  }

  /// Upload Car Image
  /// Returns the URL of the uploaded image
  Future<String?> uploadImage(File file) async {
    try {
      String fileName = file.uri.pathSegments.last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await _api.uploadImage("/upload", formData);
      if (response.statusCode == 200) {
        // Assuming response is { "url": "..." }
        return response.data["url"];
      }
      return null;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
  /// Toggle Car Status (Active/Inactive)
  Future<bool> toggleCarState(int carId) async {
    try {
      final response = await _api.patch("/ownercar/cars/$carId/state", {});
      return response.statusCode == 200;
    } catch (e) {
      print("Error toggling car state: $e");
      return false;
    }
  }

  /// Add Maintenance Record
  Future<bool> addMaintenance(int carId, String description, double cost) async {
    try {
      final response = await _api.post("/ownercar/cars/$carId/maintenances", {
        "Description": description,
        "Cost": cost,
        "Date": DateTime.now().toIso8601String(),
        "MaintenanceType": "Routine", // Default
      });
      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print("Error adding maintenance: $e");
      return false;
    }
  }
}
