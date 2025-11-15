import '../core/network/api_client.dart';
import '../core/constants/api_constants.dart';
import '../models/admin.dart';

class AdminService {
  final ApiClient _apiClient = ApiClient();

  // GET all admins
  Future<List<Admin>> getAllAdmins() async {
    try {
      final response = await _apiClient.get(ApiConstants.adminEndpoint);
      final List<dynamic> data = response.data;
      return data.map((json) => Admin.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch admins: $e');
    }
  }

  // GET dashboard data
  Future<Map<String, dynamic>> getDashboard() async {
    try {
      final response = await _apiClient.get('${ApiConstants.adminEndpoint}/dashboard');
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch dashboard: $e');
    }
  }

  // GET admin by ID
  Future<Admin> getAdminById(int id) async {
    try {
      final response = await _apiClient.get('${ApiConstants.adminEndpoint}/$id');
      return Admin.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch admin: $e');
    }
  }

  // POST create admin
  Future<Admin> createAdmin(Admin admin, String password) async {
    try {
      final data = admin.toJson();
      data['password'] = password;
      
      final response = await _apiClient.post(
        ApiConstants.adminEndpoint,
        data: data,
      );
      return Admin.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create admin: $e');
    }
  }

  // POST promote user
  Future<void> promoteUser(int userId, String newRole) async {
    try {
      await _apiClient.post(
        '${ApiConstants.adminEndpoint}/promote-user/$userId?newRole=$newRole',
      );
    } catch (e) {
      throw Exception('Failed to promote user: $e');
    }
  }
}
