class Endpoints {
  static const String baseUrl = 'https://toristask.site';

  static const String signup = '$baseUrl/api/signup';
  static const String login = '$baseUrl/api/login';
  static const String validateToken = '$baseUrl/api/validate-token';
  static const String forgotPasswordRequest =
      '$baseUrl/api/forgot-password/request';
  static const String forgotPasswordReset =
      '$baseUrl/api/forgot-password/reset';
  static const String createReport = '$baseUrl/api/reports/create';
  static const String getAnnouncements = '$baseUrl/api/announcements';
  static const String getSchedules = '$baseUrl/api/schedules';
}
