import '../services/api.dart';
import '../utils/session.dart';

class LoginController {
  final ApiService apiService = ApiService();

  Future<bool> login(String email, String password) async {
    final user = await apiService.login(email, password);
    if (user != null) {
      await saveToken(user.token); // save session
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await clearToken();
  }
}
