import 'dart:io';
import '../services/api_service.dart';
import '../utils/session.dart';

class ReportController {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> createReport({
    required String description,
    File? photo,
  }) async {
    final token = await getToken();
    final userId = await getUserId();

    if (token == null || userId == null) {
      return {'success': false, 'message': 'User not authenticated'};
    }

    return await _apiService.createReport(
      token: token,
      userId: userId,
      description: description,
      photo: photo,
    );
  }
}
