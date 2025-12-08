import '../services/api_service.dart';

class ForgotController {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> requestPasswordReset(String email) async {
    return await _apiService.requestPasswordReset(email);
  }

  Future<Map<String, dynamic>> resetPassword(
      String token, String newPassword) async {
    return await _apiService.resetPassword(token, newPassword);
  }
}
