import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../utils/endpoints.dart';

class ApiService {
  Future<User?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(Endpoints.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  Future<UserCheck?> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse(Endpoints.forgotPassword),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      return UserCheck.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }
}
