class RegistrationResponse {
  final bool success;
  final String? code;
  final String message;
  final String? token;
  final String? otp;
  final UserData? user;

  RegistrationResponse({
    required this.success,
    this.code,
    required this.message,
    this.token,
    this.otp,
    this.user,
  });

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationResponse(
      success: json['success'] ?? false,
      code: json['code'],
      message: json['message'] ?? '',
      token: json['token'],
      otp: json['otp']?.toString(),
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
    );
  }
}

class UserData {
  final String? id;
  final String name; // maps from fullName or name
  final String email;
  final String phone;
  final String? location;
  final int postsCount;
  final int readsCount;
  final String? avatar;
  final bool darkMode;
  final bool isVerified;
  final String language;

  UserData({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.location,
    this.postsCount = 0,
    this.readsCount = 0,
    this.avatar,
    this.darkMode = false,
    this.isVerified = false,
    this.language = 'en',
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      name: json['fullName'] ?? json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      location: json['location'],
      postsCount: json['postsCount'] ?? 0,
      readsCount: json['readsCount'] ?? 0,
      avatar: json['avatar'],
      darkMode: json['darkMode'] ?? false,
      isVerified: json['isVerified'] ?? false,
      language: json['language'] ?? 'en',
    );
  }
}
