import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

final storage = const FlutterSecureStorage();

Future<void> saveUser(User user) async {
  await storage.write(key: 'user_data', value: jsonEncode(user.toJson()));
}

Future<User?> getUser() async {
  final userData = await storage.read(key: 'user_data');
  if (userData != null) {
    return User.fromJson(jsonDecode(userData));
  }
  return null;
}

Future<void> clearUser() async {
  await storage.delete(key: 'user_data');
}

Future<String?> getToken() async {
  final user = await getUser();
  return user?.token;
}

Future<int?> getUserId() async {
  final user = await getUser();
  return user?.userId;
}
