import '../services/api.dart';
import '../utils/session.dart';

class LoginController {
  final ApiService apiService = ApiService();

  Future<bool> login(String username, String password) async {
    final user = await apiService.login(username, password);
    if (user != null) {
      await saveToken(user.token);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await clearToken();
  }
}
