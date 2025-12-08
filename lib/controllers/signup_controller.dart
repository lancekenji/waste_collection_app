import '../services/api_service.dart';

class SignupController {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> signup({
    required String email,
    required String password,
    required String name,
    required String barangay,
  }) async {
    return await _apiService.signup(
      email: email,
      password: password,
      name: name,
      barangay: barangay,
    );
  }
}
