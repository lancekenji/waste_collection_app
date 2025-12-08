import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../utils/endpoints.dart';

class ApiService {
  Future<Map<String, dynamic>> signup({
    required String email,
    required String password,
    required String name,
    required String barangay,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(Endpoints.signup),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'user_email': email,
          'user_password': password,
          'user_name': name,
          'user_barangay': barangay,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'success': false, 'message': 'Server error occurred'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(Endpoints.login),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'user_email': email,
          'user_password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return {
            'success': true,
            'user': User.fromJson(data),
            'message': data['message'],
          };
        } else {
          return {'success': false, 'message': data['message']};
        }
      } else {
        return {'success': false, 'message': 'Server error occurred'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  Future<Map<String, dynamic>> validateToken(String token, int userId) async {
    try {
      final response = await http.post(
        Uri.parse(Endpoints.validateToken),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'token': token,
          'user_id': userId.toString(),
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'success': false, 'message': 'Server error occurred'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  Future<Map<String, dynamic>> requestPasswordReset(String email) async {
    try {
      final response = await http.post(
        Uri.parse(Endpoints.forgotPasswordRequest),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'user_email': email},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'success': false, 'message': 'Server error occurred'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  Future<Map<String, dynamic>> resetPassword(
      String token, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse(Endpoints.forgotPasswordReset),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'token': token,
          'new_password': newPassword,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'success': false, 'message': 'Server error occurred'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  Future<Map<String, dynamic>> createReport({
    required String token,
    required int userId,
    required String description,
    File? photo,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(Endpoints.createReport),
      );

      request.headers['X-WCSM-TOKEN'] = token;
      request.fields['user_id'] = userId.toString();
      request.fields['report_description'] = description;

      if (photo != null) {
        request.files.add(
          await http.MultipartFile.fromPath('report_photo', photo.path),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'success': false, 'message': 'Server error occurred'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  Future<Map<String, dynamic>> getAnnouncements(String token) async {
    try {
      final response = await http.get(
        Uri.parse(Endpoints.getAnnouncements),
        headers: {'X-WCSM-TOKEN': token},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final announcements = (data['data'] as List)
              .map((json) => Announcement.fromJson(json))
              .toList();
          return {'success': true, 'announcements': announcements};
        } else {
          return {'success': false, 'message': data['message']};
        }
      } else {
        return {'success': false, 'message': 'Server error occurred'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  Future<Map<String, dynamic>> getSchedules(String token, int userId) async {
    try {
      final response = await http.get(
        Uri.parse('${Endpoints.getSchedules}?user_id=$userId'),
        headers: {'X-WCSM-TOKEN': token},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final schedules = (data['data'] as List)
              .map((json) => Schedule.fromJson(json))
              .toList();
          return {'success': true, 'schedules': schedules};
        } else {
          return {'success': false, 'message': data['message']};
        }
      } else {
        return {'success': false, 'message': 'Server error occurred'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }
}
