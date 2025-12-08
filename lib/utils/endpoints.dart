class Endpoints {
  static const String baseUrl = 'http://your-domain.com/api';

  static const String signup = '$baseUrl/signup';
  static const String login = '$baseUrl/login';
  static const String validateToken = '$baseUrl/validate-token';
  static const String forgotPasswordRequest = '$baseUrl/forgot-password/request';
  static const String forgotPasswordReset = '$baseUrl/forgot-password/reset';
  static const String createReport = '$baseUrl/reports/create';
  static const String getAnnouncements = '$baseUrl/announcements';
  static const String getSchedules = '$baseUrl/schedules';
}