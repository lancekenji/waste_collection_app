import '../models/user_model.dart';
import '../utils/session.dart';

class ProfileController {
  Future<User?> getUser() async {
    return await getUser();
  }

  Future<void> updateUser(User user) async {
    await saveUser(user);
  }
}
