import 'location_service.dart';
import 'user_service.dart';
import 'car_service.dart';

class TrackingManager {
  final LocationService _loc = LocationService();
  final UserService _userService = UserService();
  final CarService _carService = CarService();

  int? _activeCarId;

  Future<void> startForUser({
    required String firebaseUid,
    int distanceFilter = 50,
  }) async {
    final ok = await _loc.requestPermission();
    if (!ok) return;

    final pos = await _loc.getOnce();
    if (pos != null) {
      await _safePush(firebaseUid, pos.latitude, pos.longitude);
    }

    _loc.startTracking(
      distanceFilter: distanceFilter,
      onUpdate: (lat, lng) async {
        await _safePush(firebaseUid, lat, lng);
      },
    );
  }

  Future<void> _safePush(
    String uid,
    double lat,
    double lng,
  ) async {
    try {
      // update USER location
      await _userService.updateUserLocation(
        firebaseUid: uid,
        latitude: lat,
        longitude: lng,
      );
    } catch (e) {
      print("updateUserLocation failed: $e");
    }

    final carId = _activeCarId;
    if (carId != null) {
      try {
        await _carService.updateCarLocation(
          carId: carId,
          latitude: lat,
          longitude: lng,
        );
      } catch (e) {
        print("updateCarLocation failed: $e");
      }
    }
  }

  void attachCar(int carId) {
    _activeCarId = carId;
  }

  void detachCar() {
    _activeCarId = null;
  }

  Future<void> stop() => _loc.stopTracking();
}
