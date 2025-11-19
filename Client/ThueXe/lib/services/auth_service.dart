class AuthService {
  Future<bool> register({
    required String email,
    required String phone,
    required String password,
  }) async {
    await Future.delayed(Duration(seconds: 1));
    return true; // fake success
  }
}
