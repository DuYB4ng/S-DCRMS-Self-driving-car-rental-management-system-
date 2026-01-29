import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationService {
  StreamSubscription<Position>? _subscription;

  /// 1️⃣ Xin quyền GPS
  Future<bool> requestPermission() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return false;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  ///  Lấy vị trí 1 lần (sau login)
  Future<Position?> getOnce() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }

  /// Bắt đầu tracking liên tục
  void startTracking({
    required Future<void> Function(double lat, double lng) onUpdate,
    int distanceFilter = 50,
  }) {
    stopTracking(); // tránh start chồng

    _subscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter,
      ),
    ).listen((pos) async {
      await onUpdate(pos.latitude, pos.longitude);
    });
  }

  /// Dừng tracking (khi logout)
  Future<void> stopTracking() async {
    await _subscription?.cancel();
    _subscription = null;
  }


  //Ask for permission
  Future<bool> ensurePermissionAskedOnce() async {
  final prefs = await SharedPreferences.getInstance();

  // Check quyền hiện tại
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return false;

  var permission = await Geolocator.checkPermission();

  // Nếu đã được cấp sẵn -> ok luôn, không hỏi
  if (permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse) {
    return true;
  }

  // Nếu user đã từng bị hỏi rồi -> không hỏi lại nữa
  final asked = prefs.getBool("location_permission_asked") ?? false;
  if (asked) {
    return false;
  }

  // Chưa từng hỏi -> hỏi 1 lần
  prefs.setBool("location_permission_asked", true);
  permission = await Geolocator.requestPermission();

  return permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse;
}

}
