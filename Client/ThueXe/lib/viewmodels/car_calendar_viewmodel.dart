import 'package:flutter/material.dart';
import '../services/calendar_service.dart';

class CarCalendarViewModel extends ChangeNotifier {
  final int carId;
  final CalendarService _service = CalendarService();

  bool isLoading = false;
  List<DateTime> busyDates = [];

  CarCalendarViewModel(this.carId);

  void loadCalendar() async {
    isLoading = true;
    notifyListeners();

    try {
      final list = await _service.fetchCalendar(carId);
      busyDates = list.map((e) => DateTime.parse(e['date'].toString())).toList();
    } catch (e) {
      print("Error loading calendar: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  bool isBusy(DateTime date) {
    return busyDates.any((d) => isSameDay(d, date));
  }

  // Simple check for same day (ignoring time)
  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> toggleDate(DateTime date) async {
    // Assuming UI prevents past dates, but good to check
    if (date.isBefore(DateTime.now().subtract(const Duration(days: 1)))) return;

    bool currentlyBusy = isBusy(date);
    
    // Optimistic Update
    if (currentlyBusy) {
      busyDates.removeWhere((d) => isSameDay(d, date));
    } else {
      busyDates.add(date);
    }
    notifyListeners();

    bool success;
    if (currentlyBusy) {
      success = await _service.unblockDate(carId, date);
    } else {
      success = await _service.blockDate(carId, date);
    }

    if (!success) {
      // Revert if failed
      if (currentlyBusy) {
         busyDates.add(date);
      } else {
         busyDates.removeWhere((d) => isSameDay(d, date));
      }
      notifyListeners();
      // Show snackbar or error in specific way if needed
    }
  }
}
