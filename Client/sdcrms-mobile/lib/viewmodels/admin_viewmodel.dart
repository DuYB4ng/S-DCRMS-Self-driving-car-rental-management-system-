import 'package:flutter/foundation.dart';
import '../models/admin.dart';
import '../services/admin_service.dart';

class AdminViewModel extends ChangeNotifier {
  final AdminService _adminService = AdminService();

  List<Admin> _admins = [];
  Map<String, dynamic>? _dashboardData;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Admin> get admins => _admins;
  Map<String, dynamic>? get dashboardData => _dashboardData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  int get totalAdmins => _dashboardData?['totalAdmins'] ?? 0;
  int get totalUsers => _dashboardData?['totalUsers'] ?? 0;
  int get totalStaff => _dashboardData?['totalStaff'] ?? 0;
  int get totalCustomers => _dashboardData?['totalCustomers'] ?? 0;

  // Load all admins
  Future<void> loadAdmins() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _admins = await _adminService.getAllAdmins();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load dashboard
  Future<void> loadDashboard() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _dashboardData = await _adminService.getDashboard();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create admin
  Future<bool> createAdmin(Admin admin, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _adminService.createAdmin(admin, password);
      await loadAdmins(); // Refresh list
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Promote user
  Future<bool> promoteUser(int userId, String newRole) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _adminService.promoteUser(userId, newRole);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
