import 'package:flutter/material.dart';

class Responsive {
  // Dưới 850px là mobile
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 850;

  // Từ 850px đến 1100px là tablet
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 850 &&
      MediaQuery.of(context).size.width < 1100;

  // Từ 1100px trở lên là desktop
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;
}
