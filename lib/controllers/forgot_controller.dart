import '../services/api.dart';
import '../utils/session.dart';

class ForgotController {
  final ApiService apiService = ApiService();

  Future<String> forgotPassword(String email) async {
    final user = await apiService.forgotPassword(email);
    if (user != null) {
      if (!user.isValid) {
        return 'Account with that username doesn\'t exists!';
      }
      return 'Success';
    }
    return 'Error';
  }
}
