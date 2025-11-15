import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  String selectedCity = "Hồ Chí Minh";

  DateTime receiveDate = DateTime.now();
  TimeOfDay receiveTime = TimeOfDay.now();

  DateTime returnDate = DateTime.now().add(Duration(days: 1));
  TimeOfDay returnTime = TimeOfDay.now();

  void setCity(String city) {
    selectedCity = city;
    notifyListeners();
  }

  void setReceiveDate(DateTime date) {
    receiveDate = date;
    notifyListeners();
  }

  void setReceiveTime(TimeOfDay time) {
    receiveTime = time;
    notifyListeners();
  }

  void setReturnDate(DateTime date) {
    returnDate = date;
    notifyListeners();
  }

  void setReturnTime(TimeOfDay time) {
    returnTime = time;
    notifyListeners();
  }
}
