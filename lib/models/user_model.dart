class User {
  final String userId;
  final String username;
  final String token;

  User({required this.userId, required this.username, required this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'].toString(),
      username: json['username'],
      token: json['token'],
    );
  }
}

class UserCheck {
  final String email;
  final bool isValid;

  UserCheck({required this.email, required this.isValid});

  factory UserCheck.fromJson(Map<String, dynamic> json) {
    return UserCheck(email: json['username'], isValid: json['isValid']);
  }
}
