import '../services/api_service.dart';
import '../utils/session.dart';

class LoginController {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final result = await _apiService.login(email, password);
    
    if (result['success'] == true) {
      await saveUser(result['user']);
      return {'success': true, 'message': result['message']};
    }
    
    return {'success': false, 'message': result['message']};
  }

  Future<void> logout() async {
    await clearUser();
  }
}
