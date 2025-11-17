class DashboardStats {
  final int totalUsers;
  final int activeBookings;
  final double revenue;
  final int totalCars;
  final double systemHealth;

  DashboardStats({
    required this.totalUsers,
    required this.activeBookings,
    required this.revenue,
    required this.totalCars,
    required this.systemHealth,
  });
}

class DashboardMenuItem {
  final String title;
  final String icon;
  final String route;
  final List<String>? subItems;

  DashboardMenuItem({
    required this.title,
    required this.icon,
    required this.route,
    this.subItems,
  });
}
