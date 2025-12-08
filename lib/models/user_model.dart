class User {
  final int userId;
  final String userName;
  final String userEmail;
  final String userBarangay;
  final String token;

  User({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userBarangay,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      userName: json['user_name'],
      userEmail: json['user_email'],
      userBarangay: json['user_barangay'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_name': userName,
      'user_email': userEmail,
      'user_barangay': userBarangay,
      'token': token,
    };
  }
}

class Announcement {
  final int announcementId;
  final String announcementTitle;
  final String announcementDescription;
  final String? announcementPhoto;
  final String dateTime;

  Announcement({
    required this.announcementId,
    required this.announcementTitle,
    required this.announcementDescription,
    this.announcementPhoto,
    required this.dateTime,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      announcementId: json['announcement_id'],
      announcementTitle: json['announcement_title'],
      announcementDescription: json['announcement_description'],
      announcementPhoto: json['announcement_photo'],
      dateTime: json['date_time'],
    );
  }
}

class Schedule {
  final int scheduleId;
  final String scheduleDate;
  final String scheduleTime;
  final String barangay;
  final String wasteType;

  Schedule({
    required this.scheduleId,
    required this.scheduleDate,
    required this.scheduleTime,
    required this.barangay,
    required this.wasteType,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      scheduleId: json['schedule_id'],
      scheduleDate: json['schedule_date'],
      scheduleTime: json['schedule_time'],
      barangay: json['barangay'],
      wasteType: json['waste_type'],
    );
  }

  List<String> get wasteTypes => wasteType.split(',');
}
