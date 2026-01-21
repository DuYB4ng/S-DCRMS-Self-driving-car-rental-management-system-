import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/car.dart';
import '../services/owner_car_service.dart';

class OwnerCarViewModel extends ChangeNotifier {
  final OwnerCarService _service = OwnerCarService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Car> cars = [];
  bool isLoading = false;
  String? errorMessage;
  int? currentOwnerId;
  String get baseUrl => _service.baseUrl;

  // Initial load
  Future<void> loadCars() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      errorMessage = "User not logged in";
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final ownerData = await _service.getOwnerByUid(uid);
      if (ownerData != null) {
        currentOwnerId = ownerData['ownerCarId']; // Check casing 
        final carsList = ownerData['cars'] as List<dynamic>?;
        if (carsList != null) {
          cars = carsList.map((e) => Car.fromJson(e)).toList();
        } else {
          cars = [];
        }
      } else {
        // Try creating profile automatically
        final created = await _service.createOwnerProfile(uid);
        if (created) {
           // Recursive retry (one time)
           // But avoid infinite loop - simpler to just recall loadCars() or manually fetch
           // Let's manually fetch clearly
           final retryOwner = await _service.getOwnerByUid(uid);
           if (retryOwner != null) {
              currentOwnerId = retryOwner['ownerCarId'];
              cars = [];
              // Successful auto-recovery
           } else {
              errorMessage = "Failed to recover owner profile.";
           }
        } else {
           errorMessage = "Owner profile not found. Please contact support.";
        }
      }
    } catch (e) {
      errorMessage = "Failed to load cars: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addCar(Car car) async {
    if (currentOwnerId == null) return false;
    isLoading = true;
    notifyListeners();
    try {
      final newCar = await _service.addCar(currentOwnerId!, car);
      if (newCar != null) {
        cars.add(newCar);
        notifyListeners();
        return true;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<bool> updateCar(Car car) async {
    if (car.carId == null) return false;
    isLoading = true;
    notifyListeners();
    try {
      final updated = await _service.updateCar(car.carId!, car);
      if (updated != null) {
        final index = cars.indexWhere((c) => c.carId == car.carId);
        if (index != -1) {
          cars[index] = updated;
        }
        notifyListeners();
        return true;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<bool> deleteCar(int carId) async {
    isLoading = true;
    notifyListeners();
    try {
      final success = await _service.deleteCar(carId);
      if (success) {
        cars.removeWhere((c) => c.carId == carId);
        notifyListeners();
        return true;
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<String?> uploadImage(File file) async {
    // Returns URL
    return await _service.uploadImage(file);
  }

  Future<void> signOut() async {
    await _auth.signOut();
    cars.clear();
    currentOwnerId = null;
    notifyListeners();
  }
  
  Future<void> toggleCarStatus(int carId) async {
    final success = await _service.toggleCarState(carId);
    if (success) {
      final index = cars.indexWhere((c) => c.carId == carId);
      if (index != -1) {
        // Toggle locally to avoid full reload
        final oldCar = cars[index];
        // Assuming we rely on reload, OR we manually flip the boolean if we had one.
        // The car model might have 'isActive' or 'status'. 
        // Let's just reload for safety or verify model.
        // For now, reload checks.
        await loadCars(); 
      }
    }
  }

  Future<bool> addMaintenance(int carId, String description, double cost) async {
    return await _service.addMaintenance(carId, description, cost);
  }
}
