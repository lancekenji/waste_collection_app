class User {
  final String user_id;
  final String username;
  final String token;

  User({required this.user_id, required this.username, required this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      user_id: json['user_id'].toString(),
      username: json['username'],
      token: json['token'],
    );
  }
}
